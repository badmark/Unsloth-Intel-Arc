# Unsloth-Intel-Arc
I was unable to find a working Dockerfile to run Unsloth with an Intel Arc GPU and my attempts to install it on my system became a Python dependency circle of hell. Hopefully this helps anyone with that would like to run Unsloth on their PC with an Intel Arc GPU.

**Build and run**

`docker build --no-cache -t unsloth-intel-arc:latest .`


`docker run -d \
  --name unsloth-intel-container \
  --user root \
  -e LD_LIBRARY_PATH="/root/.unsloth/studio/unsloth_studio/lib/python3.12/site-packages/torch/lib:/usr/local/lib:$LD_LIBRARY_PATH" \
  --group-add video \
  --group-add ==RENDER GROUP ID== \
  --device=/dev/dri \
  -p 8888:8888 \
  -v $(pwd)/work:/workspace/work \
  unsloth-intel-arc:latest`


**To get your RENDER group ID:**

getent group render | cut -d: -f3
