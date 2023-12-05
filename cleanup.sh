#!/bin/bash
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]
then
  printf "You need to provide a directory, Github username and Dockerhub username.\n"
  exit 0
else
  CURRENT_DIR=${PWD}
  CODE_PATH=$1
  GIT_USER=$2
  DOCKER_USERNAME=$3
  RESPOSITORY=$(basename ${CODE_PATH})
  printf "Removing .git from project directory\n"
  cd ${CODE_PATH}
  rm -rf .git
  cd ${CURRENT_DIR}
  printf "Deleting running jenkins container\n"
  nerdctl rm -f jenkins
  printf "Deleteing container jenkins:demo image\n"
  nerdctl rmi ${DOCKER_USERNAME}/jenkins:demo
  printf "Deleting generated ssh keys\n"
  rm id_rsa_jenkins*

  printf "Deleting Github repository\n"
  gh repo delete github.com/${GIT_USER}/${RESPOSITORY}

  printf "\nReset Jenksfile Git Path\n"
  sed -i '' "s/${RESPOSITORY}/PATH/g" ${CURRENT_DIR}/Jenkinsfile
fi