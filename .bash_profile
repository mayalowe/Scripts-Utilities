# *********************************************************
#         Eric Lowe's .bash_profile
# ---------------------------------------------------------
# Description: holds all my BASH configurations and aliases
#
# *********************************************************
source ~/.bashrc
#   -------------------------------
#   1. ENVIRONMENT CONFIGURATION
#   -------------------------------
#
# Set paths
# ---------------------------------------------------------
export PATH="$PATH:/usr/local/bin/"
export PATH="/usr/local/git/bin:/usr/local/bin:/usr/local/:/usr/local/sbin:$PATH"
export PYTHONPATH="$PYTHONPATH:/usr/local/lib/python3.6/site-packages"

# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PATH

# Set default editor to Atom
# ---------------------------------------------------------
export EDITOR="atom --wait"

# Add color to terminal
# ---------------------------------------------------------
export CLICOLOR=1

export PS1='\u: \W \$ '

#   ---------------------------------------------------------
#   2. FILE AND FOLDER MANAGEMENT
#   ----------------------------------------------------------

zipf () { zip -r "$1".zip "$1" ; }   # zipf: To create a ZIP archive of a folder

#   extract:  Extract most know archives with one command
#   ---------------------------------------------------------
extract () {
  for arg in $@ ; do
      case $arg in
  	*.tar) tar -xvf $arg ;;
  	*.tar.gz) tar -xvzf $arg ;;
  	*.tar.Z) tar -xvf $arg ;;
  	*.tar.bz2) tar -jvxf $arg ;;
  	*.tar.bz) tar -jvxf $arg ;;
  	*.tgz) tar -xvzf $arg ;;
  	*.tbz) tar -jvxf $arg ;;
  	*.tbz2) tar -jvxf $arg ;;
  	*.gz) gunzip -d $arg ;;
  	*.Z) uncompress $arg ;;
  	*.zip) unzip $arg ;;
  	*.bz2) bunzip2 $arg ;;
  	*.bz) bunzip2 $arg ;;
  	*) echo "extract: $arg has no compression extension" ;;
      esac # case $arg in
  done # for arg in $@ ;
}


#   ---------------------------------------------------------
#   3. FUNCTIONS
#   ---------------------------------------------------------
# check_dir -- checks if a given argument is a valid directory
# usage: check_dir [directory]
check_dir () {
  if [[ ! -d "${1}" ]] # if the argument is not a directory
  then # then print error message and exit
    echo "${1} is not a valid directory on your system."
    echo "Please enter a valid directory path."
    exit 1
  fi
  return $? # returns default exit status otherwise
}

# check_integer -- takes a cl argument as input and evaluates if it is an check_integer
# usage: check_integer int
check_integer () {
  if [ "$1" -eq "$1" ] 2>/dev/null # test if argument is an integer
  then
      echo "$1 is an integer !!"
  else
      echo "ERROR: argument to l must be an integer."
      exit 1
  fi
  return $? # returns default exit status
}

# log -- function to enable verbose settings to work
# usage: log "input"
log () {
  if [[ $_V -eq 1 ]]; then
    echo "$@"
  fi
}

# log_debug -- function to allow debugging functionality
# usage: log_debug "input"
log_debug () {
  if [[ $_T -eq 1 ]]; then
    echo "$@"
  fi
}

# log_error -- function to enable error-only output
# usage: log_error "input"
log_error () {
  if [[ $_E -eq 1 ]]; then
    echo "$@"
  fi
}

# print_usage -- prints usage statement to STDOUT
# usage: print_usage
print_usage () {
  echo "usage: $0 [-options];"
  echo "Use $0 -h for help"
}
