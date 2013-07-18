# make it so number 1
alias engage="play -n synth whitenoise band -n 100 24 band -n 300 100 gain +5"

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias moviehaxing="cat /dev/urandom | hexdump"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# laziness forces me here
function md5-verify()
{
	if [ $# -eq 0 ]
	then
    	echo "Missing args. $FUNCNAME file md5"
		return 1
	fi

	if [ ! -f $1 ]
	then
		echo "$1 does not exist!"
		return 1
	fi 

	c=`echo $2 | awk '{ print toupper($0) }'`

	if [ `md5sum $1 | awk '{ print toupper($1) }'` == "$c" ]
	then
		echo "OK"
		return 0
	fi

	echo "Not OK"
	return 1
}
