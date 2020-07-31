
# Environment setup
**Load the python module**:
```
module load python/3.8  
# you can specify the python version you want
```
**Create a virtual environment** for your project (recomended practice):
```
# go to your project directory
cd dir/for/my/project
# create venv
python -m venv myvenv   # "myenv" is the name of the venv you create
```
Now you will find a folder named `myenv/ `under your project directory.pi

You always need to **activate the venv** before **doing anything** with python:
```
source ./myvenv/bin/activate
```
Now you can **Install the packages** you need, for example:
```
pip install pandas
```
You may need a list of varioius packages for your project, for which you can use a `requirements.txt` file and install from it using: `pip install -r requirements.txt`.  
For more info check the [official document on venv](https://docs.python.org/3/tutorial/venv.html).

## Set up Jupyter (optional)
To use Jupyter notebook or lab, we need to install and setup the environment.

Install Jupyter Notebook:
```
pip install jupyter
```
Create a wrapper script (`notebook.sh` located in `.venv/bin/`) that launches Jupyter Notebook:
```
# save the command into a script
echo -e '#!/bin/bash\nunset XDG_RUNTIME_DIR\njupyter notebook --ip $(hostname -f) --no-browser' > $VIRTUAL_ENV/bin/notebook.sh

# make the script executable
chmod u+x $VIRTUAL_ENV/bin/notebook.sh
```
Install some necessary extensions:
```
pip install jupyterlmod
jupyter nbextension install --py jupyterlmod --sys-prefix
jupyter nbextension enable --py jupyterlmod --sys-prefix
jupyter serverextension enable --py jupyterlmod --sys-prefix
# proxy web services (optional)
pip install nbserverproxy
jupyter serverextension enable --py nbserverproxy --sys-prefix
```


# Run Python
On Compute Canada, ALL computation jobs should be submitted to the `Slurm` scheduler to run on a computing node (instead of the login node).

## Run Python code (.py)
Use `sbatch` command to submit jobs. We can specify the resources that we demand in a `run_python.sh` file:
```
#!/bin/bash
#SBATCH --account=def-yourPI
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=4G
#SBATCH --job-name=test
#SBATCH --output=%x-%j.out

python code_example.py
```
Substitute "yourPI" in the `--account=def-yourPI` to your supervisor's Compute Canada ID (e.g. "_hptan_").  
In the above example which I name as "_test_", we ask for 1 hour running time with 2 CPU cores and 4G RAM.  
The `--output` option set the ouput to be stored in a `taskName-jobId.out` file. 

Submit the above `.sh` file in the terminal:
```
sbatch run_python.sh
```

## Parallel jobs (advanced)
In some cases, we need to run a program with different coefficients. E.g. when tuning the hyperparameters of a machine learning model. Sequential execution might be too time consuming.   
Besides using parallel computing inside our Python program, we can  the `array jobs` to multiplicate the program with different input coefficients. Use the following command in `.sh` file:
```
#!/bin/bash
#SBATCH --account=def-caporos1
#SBATCH --array=1-10
#SBATCH --time=00:02:00
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=2G
#SBATCH --job-name=test_parallel
#SBATCH --output=%x-%j.out

python code_example_parallel.py $SLURM_ARRAY_TASK_ID
```
Notice that we add a `--array=1-10` option, which means we multiplicate the program 10 times with different input coefficient = [1, 2, ..., 10], which is denoted in the system as the variable of name `$SLURM_ARRAY_TASK_ID`.

In the `.py` file we should also add a few lines to accept the input variable:
```
import sys  # to get system variables

coeff = int(sys.argv[1])
```
This tell the program to get the value of the input variable `$SLURM_ARRAY_TASK_ID`.


## Run Jupyter notebook (optional)
We need an **_interactive job_** (using `salloc` command) to run the Jupyter notebook:
```
salloc --time=1:0:0 --ntasks=1 --cpus-per-task=2 --mem-per-cpu=4G --account=def-yourPI srun $VIRTUAL_ENV/bin/notebook.sh
```

We are expected to see the output to include the info like below:
```
The Jupyter Notebook is running at:
        https://gra798.graham.sharcnet:8888/?token=7ed7059fad64446f837567e3
```
This address contains the server name and port where the Jupyter running on (`hostname`: "_blg9322.int.ets1.calculquebec.ca_", `port number`: "_8888_"), and the token to for security verification.

Now, on our local computer (say Windows PC), we need to use **SSH tunnel to forward** the running Jupyter server. Open a local tab in your SSH software (e.g. MobaXterm), and run:
```
ssh -L 8888:<hostname:port> <username>@<cluster>.computecanada.ca
```
Substitute the `<hostname>`, `<port>` with the ones from the previous address in the output.  
Substitute the `<username>`, `<cluster>` with the your username and cluster you are using.  
E.g. `username` is "hptan", `cluster` is "graham", then the command is:  
```
ssh -L 8888:gra798.graham.sharcnet:8888 hptan@graham.computecanada.ca
```
Finally, we can open our browser and go to the address:
```
http://localhost:8888/?token=<token>
```
Substitute the `token` with the token from the previous output address (e.g. "_7ed7059fad64446f837567e3_").

Voila!


# Reference:  
ComputeCanada official wiki on:
- [Running jobs](https://docs.computecanada.ca/wiki/Running_jobs).
- [Python](https://docs.computecanada.ca/wiki/Python).
- [Jupyter](https://docs.computecanada.ca/wiki/Jupyter).
