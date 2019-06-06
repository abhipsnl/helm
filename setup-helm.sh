#!/bin/sh

ECHO_CMD="echo -e"
NORM_CODE="\033[0m"
GREEN_CODE="\033[32m"
RED_CODE="\033[31m"

############################################
#  USAGE: ./setup-helm.sh
#
############################################

# User defined functions

display() {
    MSG="$1"
    ACTION="$2"
    case $ACTION in
    INFO)
        printf "%20s${MSG}%80s [ INFO ]"
    ;;
    ERROR) 
        printf "${RED_CODE} %20s${MSG}%80s [ ERROR ] ${NORM_CODE}"
    ;;
    OK)
        printf "${GREEN_CODE} %20s${MSG}%80s [ OK ] ${NORM_CODE}"
    ;;
    esac
}
 setup_helm() {
    display "Creating \"tiller\" service account om kube-system namespace" "INFO"
    kubectl create serviceaccount -n kube-system tiller
    if [ $? -ne 0 ];then
        display "Failed while creating service account for tiller" "ERROR"
        exit 1
    fi
    
    display "Creating clusterrolebinding" "INFO"
    kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
    if [ $? -ne 0 ];then
        display "Failed while creating clusterrolebinding" "ERROR"
        exit 1
    fi
    display "Initializing tiller" "INFO"
    helm init --service-account tiller
    if [ $? -ne 0 ];then
        display "Failed while creating clusterrolebinding" "ERROR"
        exit 1
    fi
    display "Successfully setup helm" "OK"

}

# Main
clear
setup_helm
