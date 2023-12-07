#!/bin/bash
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]
then
  printf "You need to provide a project directory, Github username and Dockerhub username.\n"
  exit 0
else
  ssh-keygen -f ./id_rsa_jenkins -q -N ""
  CURRENT_DIR=${PWD}
  CODE_PATH=$1
  GIT_USER=$2
  DOCKER_USERNAME=$3
  RESPOSITORY=$(basename ${CODE_PATH})

  printf "\nCopy maven settings.xml to code directory....\n"
  cp -R .maven ${CODE_PATH}
  printf "\nSuccessfully copied settings.xml\n"

  printf "\nCopy gitignore\n"
  cp gitignore-template ${CODE_PATH}/.gitignore
  printf "\nSuccessfully copied gitignore template\n"

  printf "\nBuilding container image"
  nerdctl build -t "${DOCKER_USERNAME}/jenkins:demo" -f Dockerfile .

  printf "\nCreating Private GitHub repository and initializing local project\n"
  gh repo create ${RESPOSITORY} --private

  git -C ${CODE_PATH} init
  git -C ${CODE_PATH} add .
  git -C ${CODE_PATH} commit -m "Setup demo"
  git -C ${CODE_PATH} remote add origin git@github.com:${GIT_USER}/${RESPOSITORY}.git
  cd ${CODE_PATH}
  git push -u -f origin main

  printf "\nConfiguring and setting GitHub Deploy keys\n"
  gh repo deploy-key add ${CURRENT_DIR}/id_rsa_jenkins.pub -t Jenkins

  printf "\nStarting Jenkins container on port 8080\n"
  nerdctl run -d --name jenkins -p 8080:8080 --env JENKINS_ADMIN_ID=admin --env JENKINS_ADMIN_PASSWORD=password ${DOCKER_USERNAME}/jenkins:demo

  printf "\nUpdating Jenksfile with Git Path\n"
  sed -i '' "s/PATH/${RESPOSITORY}/g" ${CURRENT_DIR}/Jenkinsfile
fi
