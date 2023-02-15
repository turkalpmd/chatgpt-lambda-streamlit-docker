# Creating a Lambda Function to Use OpenAI API

![]("https://github.com/turkalpmd/chatgpt-lambda-streamlit-docker/blob/master/gpt.jpg")
#
#
* This guide outlines the steps to create a Lambda function that utilizes the OpenAI API to generate text.

## Prerequisites
* Before you can create the Lambda function, you must complete the following steps:

* Create an OpenAI account and generate an API key.
* Install the OpenAI library locally for the Lambda layer.

## Creating the Lambda Function
1 - Create a new directory for the Lambda function by terminal:

````
mkdir lambda
cd lambda
````
2 - Inside the directory, create another directory named "python" and install the OpenAI library:

```
mkdir python
cd python
pip3 install openai -t ./
cd ..

```

3 - Compress the "python" directory into a .zip file:
```
zip -r python.zip .

```

4 - Create the Lambda function on the AWS Console, and configure it with the following settings:

* Runtime: Python 3.8
* Handler: index.lambda_handler
* Timeout: 60 seconds
* Memory: 256 MB
* Role: Choose or create an execution role that grants access to the necessary resources.

5 - Add the "python.zip" file as a layer to the function. For more information, refer to the AWS documentation on creating and using Lambda layers.

6 - Add an environment variable for the OpenAI API key.

7 - Use the following code as the function's handler:

```
import os
import json
import openai

def lambda_handler(event, context):
    prompt = event["queryStringParameters"]["prompt"]
    KEY = os.environ["API_KEY"]
    openai.api_key = KEY
    model_engine = "text-davinci-003"
    response = openai.Completion.create(engine=model_engine, prompt=prompt, max_tokens=250)
    text_result = response.choices[0].text
    return {
        'statusCode': 200,
        'body': json.dumps(text_result, ensure_ascii=False, indent=4)
    }

```

This code uses the OpenAI API to generate text based on the provided prompt and returns the result in the response body.

###  Using the Lambda Function with API Gateway
* To use the Lambda function with API Gateway, create a new API Gateway REST API and add a new resource and method. Configure the method to use the Lambda function as its integration and deploy the API to make it publicly accessible.

"https://<api_gateway_endpoint>/myfunction?prompt="My+prompt+goes+here.""

## Create Streamlit Model

* The Python code is written to create a simple user interface using Streamlit, a popular open-source framework for creating data science applications. The UI allows the user to enter a prompt, and when the "Ask to ChatGPT" button is clicked, the input prompt is sent to an AWS Lambda function that uses OpenAI's GPT-3 to generate a response.

* The code begins by importing the necessary libraries: streamlit, requests, and PIL. Streamlit is used for creating the UI, requests is used for sending HTTP requests to the AWS Lambda function, and PIL is used for loading the ChatGPT logo image.

* The st.title method is used to display the title "ChatGPT & AWS Lambda on Streamlit". This is followed by loading the ChatGPT logo image using the PIL library and displaying it using the st.image method.

* The user is then prompted to enter a key prompt using the st.text_input method. When the user clicks the "Ask to ChatGPT.." button using the st.button method, the code checks if the input prompt is longer than 250 characters. If it is, an error message is displayed using the st.error method. If it is not, a URL is used to send the input prompt to the AWS Lambda function using the requests.get method.

* While waiting for the response from the AWS Lambda function, a spinner is displayed using the st.spinner method. Once the response is received, it is displayed using the st.success method.

* This code can be run locally or deployed to a server or cloud platform, such as Heroku, AWS, or Google Cloud. The necessary dependencies for running the code can be installed using the requirements.txt file.

## Create requirements.txt

- We need; streamlit, pymongo, requests, datetime, Pillow libraries for python code

When calling the API endpoint, pass the desired prompt as a query string parameter, like so:

### Deploying model

Docker is a powerful tool that enables you to package your application and its dependencies into a single image, which can be easily deployed to different environments. In order to deploy your ChatGPT application on an EC2 instance, you will need to build a Docker image using the provided Dockerfile.

To build the Docker image, you will need to run the following commands:

Navigate to the directory where the Dockerfile is located using the command $ cd 'path'
Run the command $ sudo docker build -t chatgpt:latest . to build the Docker image.
Once you have built the Docker image, you can run a container using the following command:

Run the command $ sudo docker run -p 80:8501 -d chatgpt:latest to start a container based on the Docker image. This will map port 80 on the host machine to port 8501 in the container.
It's worth noting that by default, Streamlit listens on port 8501. If you want to use a different port, you can modify the EXPOSE instruction in your Dockerfile to specify the desired port number, and then update the CMD instruction to use the same port number in the streamlit run command.

Additionally, before you can access your application running on an EC2 instance on ports 8501 and 80, you must add inbound rules to the instance's security group to allow incoming traffic on these ports. These rules will allow traffic from specific IP addresses or ranges to reach the instance's public IP address on these ports, enabling you to access the application via HTTP or HTTPS.

Overall, with these directions and the provided Dockerfile, you should be able to easily deploy your ChatGPT application on an EC2 instance.
