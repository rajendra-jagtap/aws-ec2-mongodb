#!/usr/bin/env bash

function help() {
    echo "Refer Readme.md"
}


function create() {
  ENV_FILE="env/${1}.tfvars"
  echo "Initiating ${1} infra creation or updation.."
  echo "============================================="
  echo
  terraform init -backend-config ${ENV_FILE}
  echo
  echo
  terraform apply -var-file ${ENV_FILE}
  echo
  echo "Configuring network infra...."
  echo "========================"
  ansible-playbook -i lib/terraform.py mongodb.yml
}

function plan() {
  ENV_FILE="env/${1}.tfvars"
  echo "Initiating ${1} infra creation or updation.."
  echo "============================================="
  echo
  terraform init -backend-config ${ENV_FILE}
  echo
  echo
  terraform plan -var-file ${ENV_FILE}

}


if [ "$#" -lt 1 ]
 then
 help
 exit 0
fi


case ${1} in

create)
shift
create ${1}
shift
;;
plan)
shift
plan ${1}
shift
;;
update)
shift
create ${1}
shift
;;
help)
shift
help
shift
;;
*)
help
shift
;;
esac

