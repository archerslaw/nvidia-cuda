# install cuDNN 9.0 
CUDNN_FILE="/root/cudnn-9.0-linux-x64-v7.tgz"
if [ ! -f "$CUDNN_FILE" ]; then
curl -fsSL https://nvidia.obs.myhwclouds.com/cudnn-9.0-linux-x64-v7.tgz -O 
fi
tar -xzf cudnn-9.0-linux-x64-v7.tgz

# copy related files to /usr/local/cuda/lib64 or /usr/local/cuda/include
cp -a ./cuda/include/cudnn.h /usr/local/cuda/include 
cp -a ./cuda/lib64/libcudnn* /usr/local/cuda/lib64 
chmod a+r /usr/local/cuda/include/cudnn.h  /usr/local/cuda/lib64/libcudnn*
rm -fr cudnn-9.0-linux-x64-v7*

# Update your environment variables in bash session or put them in your .bashrc file
export LD_LIBRARY_PATH=/usr/local/cuda/lib64/:$LD_LIBRARY_PATH
export LIBRARY_PATH=/usr/local/cuda/lib64/:$LIBRARY_PATH

# install pip
# centos6.x+7.x|rhel6.x+7.x|ubuntu14.x+16.x|opensuse42.x
yum install python*pip -y
pip install --upgrade pip

# install tensorflow-gpu
pip install tensorflow-gpu==1.6.0 --trusted-host mirrors.myhuaweicloud.com -i http://mirrors.myhuaweicloud.com/pypi/web/simple
