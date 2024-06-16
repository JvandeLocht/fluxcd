These scripts are used to automate common workflows, when working
with this repo.

encrypt.sh
This script checks if any unencrypted files are in the 
secrets folder.
If it detects an unencrypted file it encrypts it with
age and the puplic key, that is stored in this repo.
Put this line in your pre-commit hook, to call this script before every commit:
source ./scripts/encrypt.sh

setup.sh
This script setups a new Kubernetes cluster with flux.
For that it first creates the namespace flux-system
and injects the secret with the private age key in it.
The private key is expected to be at ~/.config/sops/age/keys.txt.
After that it bootstraps fluxcd into the cluster.
The two enviroment variables have to be present for that:
 - GITHUB_USER
 - GITHUB_TOKEN

validate.sh
This script is taken from the flux2 helm example.
It validates the configuration.
