# setup lima for rancher desktop so that building and pushing via nerdctl from OSX to the SAP GCR works
function setup_lima() {
    limactlr shell 0 -- sudo apk add python3
    limactlr shell 0 -- .lima/linux/google-cloud-sdk/install.sh
    limactlr shell 0 bash -c "echo 'export PATH="/Users/d060239/.lima/linux/google-cloud-sdk/bin/:$PATH"' >> /home/d060239.linux/.profile"
    limactlr shell 0 bash -c "echo 'export CLOUDSDK_CONFIG=/Users/d060239/.config/gcloud' >> /home/d060239.linux/.profile"
    limactlr shell 0 bash -c "echo 'export DOCKER_CONFIG=/Users/d060239/.docker' >> /home/d060239.linux/.profile"
}