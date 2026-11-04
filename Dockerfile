FROM pytorch/pytorch:2.3.1-cuda12.1-cudnn8-runtime

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y install \
    wget \
    git \
    libgl1 \
    libglib2.0-0 \
    google-perftools \
    libgoogle-perftools-dev

RUN groupadd -g 1000 ubuntu && useradd -m -s /bin/sh -u 1000 -g 1000 ubuntu

WORKDIR /app

RUN chown -R ubuntu:ubuntu /app

USER ubuntu

RUN git clone https://github.com/lllyasviel/stable-diffusion-webui-forge.git sd
RUN cd sd && git checkout dfdcbab685e57677014f05a3309b48cc87383167

RUN python3 -m venv --system-site-packages /app/sd/venv
RUN /app/sd/venv/bin/pip install -r /app/sd/requirements_versions.txt
RUN /app/sd/venv/bin/pip install "opencv-contrib-python<=4.10.0.84"
RUN /app/sd/venv/bin/pip install joblib

CMD ["/app/sd/webui.sh"]
