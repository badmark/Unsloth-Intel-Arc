# Unsloth-Intel-Arc
I was unable to find a working Dockerfile to run Unsloth with an Intel Arc GPU and my attempts to install it on my system became a Python dependency circle of hell. Hopefully this helps anyone with that would like to run Unsloth on their PC with an Intel Arc GPU.

**Note: This only works with dedicated GPUs, if the PC only has an integrated GPU Unsloth will revert to CPU**

**Build and run:**

`docker build -t unsloth-intel-arc:latest .`

```
docker run -d \
  --name unsloth-intel-container \
  --user root \
  -e LD_LIBRARY_PATH="/root/.unsloth/studio/unsloth_studio/lib/python3.12/site-packages/torch/lib:/usr/local/lib:\$LD_LIBRARY_PATH" \
  --group-add video \
  --group-add 109 \
  --device=/dev/dri \
  -p 8888:8888 \
  -v $(pwd)/work:/workspace/work \
  unsloth-intel-arc:latest
```

**Once the container is up run the following command to get your bootstrap password which is required to setup a new password. The interface will be avialable on port 8888**

`docker exec unsloth-intel-container cat /root/.unsloth/studio/auth/.bootstrap_password`

**If your RENDER GID is not 109 run this command to get your RENDER group ID and replace 109 with yours:**

`getent group render | cut -d: -f3`
