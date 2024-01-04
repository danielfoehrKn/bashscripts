# openstack clients must use python2.7, while brew removed the python2.7 client. 
# Need to setup a virtualenv for python 2.7 and activate it when using the openstack cli
# How to setup python 2.7
# # Download/run the legacy macOS installer (pick which one for your sys)
# https://www.python.org/downloads/release/python-2718/

# Add pip for python2.7
# curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip2.py
# python2 get-pip2.py

# Optionally check for pip updates (in case of post-eol patches)
# python2 -m pip install --upgrade pip

# Optionally add the helpers like easy_install back onto your path
# In your ~/.zprofile or whatever bash/shell profile equivalent
# PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
active_dod_env() {
 source ${HOME}/.virtualenvs/operations-env/bin/activate

 echo "run 'deactivate' to exit virtual env" 
}
