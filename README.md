# Datasharing
This repository contains the python code used in the paper **The Significance of Data-Sharing Policy**, accepted for publication in the **Journal of the European Economic Association**. The python code performs data cleaning and processing tasks, in addition to calculating key statistics and other variables used in the analysis.

## Set up
1. Clone the package from github to a local directory.
2. Add the full path to the cloned repository to your PYTHONPATH. The full path will be something similar to: `C:\Users\User\....\Datasharing\"`
3. Install the default anaconda environment, or ensure your python version and package versions are compatible with the requirements.
4. Ensure you have downloaded all datasets, and made them available at `Datasharing\data\group1` (you will need to create this folder).

#### Using the default anaconda environment

Navigate to model-apps repository and create install the virtual environment:
```
conda env create -f environment.yaml
```
This creates a virtual environment named **powanalysis**, however the environment needs to be active before use.

##### Managing the environment through the command line

To activate the environment:
```
conda activate powanalysis
```
To deactivate the environment:
```
conda deactivate
```

## Running the code
Once you have completed the setup instructions, simply run the `run_analysis_local.py` file located in `Datasharing\scripts`.

It is advised to have at least 16GB of RAM on the machine you are running the code on.