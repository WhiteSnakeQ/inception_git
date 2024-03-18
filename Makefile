NAME	= inception

DOC_F	= docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env

all:	folders
	@printf "Launch configuration ${NAME}...\n"
	@${DOC_F} up -d

folders:
	@bash srcs/requirements/tools/make_dir.sh

setub:
	sudo apt update -y && sudo apt install -y sudo ufw docker git docker-compose \
		make openbox xinit kitty firefox-esr
	sudo ufw allow 80; sudo ufw allow 42; sudo ufw allow 443; sudo ufw allow 21; sudo ufw allow 9443; \
		sudo ufw allow 8080;
	sudo sed -i "s|root	ALL=(ALL:ALL) ALL|root	ALL=(ALL:ALL) ALL\n${USER}	ALL=(ALL:ALL) ALL|g" /etc/sudoers
	sudo usermod -aG docker ${USER}
	sudo apt install -y wget curl libnss3-tools
	sudo curl -s https://api.github.com/repos/FiloSottile/mkcert/releases/latest| grep browser_download_url  | grep linux-amd64 | cut -d '"' -f 4 | wget -qi -
	sudo mv mkcert-v*-linux-amd64 mkcert
	sudo chmod a+x mkcert
	sudo mv mkcert /usr/local/bin/
	sudo sed -i "1 s|localhost|${USER}.42.fr localhost|"  /etc/hosts

build:	folders
	@printf "Building configuration ${NAME}...\n"
	@${DOC_F} up -d --build

down:
	@printf "Stopping configuration ${NAME}...\n"
	@${DOC_F} down

re:
	@printf "Rebuild configuration ${NAME}...\n"
	@${DOC_F} up -d --build

clean: down
	@printf "Cleaning configuration ${NAME}...\n"
	@docker system prune -a
	@sudo rm -rf ~/data

fclean:
	@printf "Total clean of all configurations docker\n"
	@docker stop $$(docker ps -qa)
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force
	@sudo rm -rf ~/data

.PHONY	: all build down re clean fclean
