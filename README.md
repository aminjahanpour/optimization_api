# Optoria

Optoria is a minimalistic cloud-based optimization service. Optoria was created to facilitate the optimization of cost-functions that are evaluated intermittently via physical experiments. The most prominent application of Optoria is intermittent optimization of Variational Quantum Eigensolver (VQE) where cost-function evaluation is performed on a quantum computer. Its design goal is providing maximum simplicity to users in leveraging state-of-art gradient-free solvers to minimize their real-world noisy cost-functions.

Please visit http://optoriatech.com for full introduction to the tool.

## How it works

1- Optoria sends you a set of suggestive decision variables
2- you take it to the lab and evaluate the cost-function for it
3- once ready, you send the results to Optoria.
This cycle continues until convergence is achieved or the given budget is used. Communication between you and Optoria occurs through HTTP calls. Your code or your VQE problem form and formulation is never exposed to Optoria. Only cost-function evaluations are sent to an Optoria server via HTTP requests which are simple and transparent to users. You get to protect the full privacy of your optimization problem.

## Getting Started
### setting up
Depending on your prefered programming language, download one of the files in this repository. These files provide full code to run Optoria for a simple math cost-funtion. The only thing missing in these files is an API key string. Email amin.jahanpour@gmail.com to request an API key. It is free. Once I send you the key, you will need to update the example file with the key. Then you can run the example file.

### running an optimization trial
next you need to replace the simple example file with your cost-function. Remember that Optoria works with normalized variables so you will need to unnormalize the variables before evaluation. Once done, you can execute the script.






# Usage:
`http://[server]/?key=[your_key]&req=[command]&id=[id]`

The API calls can be made from within **any** environment that can send HTTP requests. You can even use your favorite web browser to talk to the API.


## Server:
Below are the IP addresses of the available servers. Pick a server IP based on your location and use it as [server] in the usage format shown above.

| Server Code  | Location | IP |
| ------------- | ------------- | ------------- |
| **1**|  :canada: Montereal | 35.203.55.211 |
| **2**| :de:  Munich | 34.65.208.20 |

## Parameters:
The order of the below parameters does not matter.
***

### :key: key
This is your API key. You can email amin.jahanpour@gmail.com to request a key.

Please note that this key is the only security measure between you and the servers. Anyone with this key is able to delete or create projects and generally submit API commands on your behalf.

***

### :speech_balloon: req
This is the API command type being sent to the server. There are currently four API commands avaiable:
* :star: [create](https://github.com/aminjahanpour/optimization_api/wiki/create)
* :boom: [del](https://github.com/aminjahanpour/optimization_api/wiki/del)
* :question: [ask](https://github.com/aminjahanpour/optimization_api/wiki/ask)
* :arrows_clockwise: [roll](https://github.com/aminjahanpour/optimization_api/wiki/roll)
* :1234: [results](https://github.com/aminjahanpour/optimization_api/wiki/results)

***

### :paw_prints: id
This is the name of the project.

* `id` must be a unique string.

* `id` can be from 1 to 48 characters long.

* Please consider assigning different `id` to your different projects; otherwise you will need to delete the previous project with the same name in order to start a new one.

***

### :large_blue_diamond: dim
Number of decision variables in your optimization problem. `dim` is an integer and has to be greater or equal to 2.

***

### :heavy_dollar_sign: budget
The maximum number of objective function evaluations you allow for the optimization work. This number cannot exceed 10,000×`dim` or be less than 50×`dim`.

50×`dim` ≤ `budget` ≤ 10,000×`dim`

The recommended budget is 200×`dim`. For example, for a problem with 5 decision variables, the recommended budget is 1,000. 

***

### :triangular_ruler: f
A comma-separated string that contains the results of evaluations of the pending solutions. The order of the numbers in the string needs to match the order of the pending solutions.

