module load python/3.8
source "$PWD/myvenv/bin/activate"
salloc --time=1:0:0 --ntasks=1 --cpus-per-task=2 --mem-per-cpu=4G --account=def-caporos1 srun $VIRTUAL_ENV/bin/notebook.sh