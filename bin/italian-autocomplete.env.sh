# Source this file, not run it. It extends ssh auto-complete in the current environment.
# It assumes its running in config.d/bin and that its looking for *.host.conf files ../*.d/hosts.d/*.d/*.host.conf.
# If you want to look elsewhere, you can enumerate the paths via:

# source italian-autocomplete.env.sh dir0 dir1 dir2 ...

# Eventually parse $@ to turn _probe on/off

here=$(readlink -f $(dirname ${BASH_SOURCE}))
me=$(basename ${BASH_SOURCE})
paths=( "${@:-${here}/../*.d/hosts.d/*.d/*.host.conf}" )



# Wrap the distributed completion function _known_hosts_real with our own function.
# We rename _known_host_real to _known_hosts_real_dist and then define our own
# _known_hosts function. Ssh host completion becomes the union of these two functions together.

# http://stackoverflow.com/questions/1203583/how-do-i-rename-a-bash-function

copy_function() {
  test -n "$(declare -f $1)" || return 
  eval "${_/$1/$2}"
}

rename_function() {
  copy_function $@ || return
  unset -f $1
}

# Rebind _known_hosts_real once only.
if ! declare -f _known_hosts_real_dist > /dev/null ; then
    copy_function _known_hosts_real _set_aside
    rename_function _known_hosts_real _known_hosts_real_dist
fi
    

# _probe returns 0 iff $1 can be accessed. Currently slow so I don't call it.
function _probe {
    ssh -q -o BatchMode=yes -o ConnectTimeout=3 $1 exit
}

# _can_colorize returns 0 iff tab completion output can be colorized, green for connectable.
# Not yet implemented.
function _can_colorize {
    return 0
}


# Colorize $1 iff you can and $1 is connectable.
function _colorize {
    if [[ $(_can_colorize) && $(_probe $1) ]]; then
	echo -e "\e$(tput setaf 2)$1\e$(tput sgr0)"
    else
	echo $i
    fi
}



# Given a list of ssh configuration locations, try to pick out the ^Host directives enumerating potential hostnames.
# From there, if there there's a prefix, remove all candidates not matching the prefix. Then populate the
# COMPREPLY array which bash completion will eventually present.
function _generate_host_candidates {
    local prefix=$4
    declare -a h
    local completion_list=${here}/${me}-manual-additions.list.txt
    if [[ -r ${completion_list} ]] ; then
	# https://www.gnu.org/software/bash/manual/bashref.html#index-mapfile
	# brittle, comment delim must be at the beginning of the line
	# also, stdin from the output of a process using "process redirection" is magical, see http://stackoverflow.com/questions/11426529/reading-output-of-command-into-array-in-bash
	mapfile -t h < <(grep --invert-match '^#' ${completion_list})
    fi
    # grep out all `Host` directives. 
    h+=( $(grep -h '^Host ' ${paths[@]} | cut -c5- ) )  # h is the list of candidates
    # Copy only those candidates that match the prefix. Do you have a prefix?
    if [[ -z "$prefix" ]] ; then
	# No prefix, copy everything.
	COMPREPLY+=( "${h[@]}" )
    else
	# Filter out the completions that don't match the prefix.
	# TODO mcarifio: must be a better way. Sed? I should learn sed someday.
	local len=${#prefix}
	# For each candidate
	for i in ${h[@]} ; do
	    # ... does it star with the prefix?
	    if [[ ${prefix} = ${i:0:${len}} ]] ; then
		# Yes. It's a potential completion. Add it.
		COMPREPLY+=( $( _colorize $i ) )
	    fi	    
	done
    fi
}




# The wrapper. Calls the distro bash-completion function, whatever it is.
# Then add our hosts.g
function _known_hosts_real {
    # Call distro _known_host_real, which was renamed.
    _known_hosts_real_dist "$@"
    _generate_host_candidates "$@"
    return 0
}
