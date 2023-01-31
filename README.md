# article-himorna-and-f6

## Prepare environment to run the code

Download and install conda or [mamba](https://github.com/conda-forge/miniforge#mambaforge):
```bash
wget "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh"
bash Mambaforge-$(uname)-$(uname -m).sh
```

Create and activate the environment:
```bash
mamba env list
mamba env create -f conda-env.yml
mamba activate himorna-env

# For Mac
pip install bcbio-gff
```
