FROM python:3.8
LABEL maintainer "Turkalpmd  <izzetakbasli@gmail.com>"
# If you have any comment : LinkedIn - https://www.linkedin.com/in/turkalpmd/

# Repalce with your directory
WORKDIR /home/ubuntu/AWS-lambda-ChatGPT-Streamlit

COPY requirements.txt ./requirements.txt

RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt \
	&& rm -rf requirements.txt

# --------------- Configure Streamlit ---------------
RUN mkdir -p /root/.streamlit

RUN bash -c 'echo -e "\
	[server]\n\
	enableCORS = false\n\
	" > /root/.streamlit/config.toml'

# By default, Streamlit listens on port 8501. 
# If you want to use a different port, you can modify the EXPOSE instruction in your Dockerfile to specify the desired port number, 
# and then update the CMD instruction to use the same port number in the streamlit run command.

EXPOSE 8501

COPY . /home/ubuntu/AWS-lambda-ChatGPT-Streamlit

# --------------- Export envirennement variable ---------------
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

ENTRYPOINT ["streamlit","run"]

#If you modify the EXPOSE instruction in your Dockerfile, 
# you must also update the CMD instruction to specify the correct port number that 
# your application will be listening on.

CMD ["--server.port", "8501", "app.py"]

# --------------- Deploy Docker ---------------

# - Permisson rules; 

# Before you can access your application running on an EC2 instance on ports 8501 and 80, 
# you must add inbound rules to the instance's security group to allow incoming traffic on these ports. 
# These rules will allow traffic from specific IP addresses or ranges to reach the instance's public IP address on these ports,
# enabling you to access the application via HTTP or HTTPS.

# This is a Dockerfile that can be used to build a Docker image for running a ChatGPT application on an EC2 instance. 
# Once you have created the Docker image using this file, you can run a container using the following commands:
# 1. `$ cd 'path'` to the directory where the Dockerfile is located.
# 2. Run the command `$ sudo docker build -t chatgpt:latest .` to build the Docker image.
# Run the command `$ sudo docker run -p 80:8501 -d chatgpt:latest` to start a container based on the Docker image. 
# This will map port 80 on the host machine to port 8501 in the container.
# Note that port 80 is commonly used for HTTP traffic, so by mapping port 80 to port 4646 in the container,
# you can access the application using just the DNS address of the EC2 instance (i.e. without specifying a port number).
