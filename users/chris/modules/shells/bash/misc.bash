#!/usr/bin/env bash

echo "This script is not actually intended to be run, wtf are you doing?"
exit 1

#@@@@@@
# ~/.local/lib/fail
#!/usr/bin/env bash

exit 1

#@@@@@@
# ~/.local/lib/relpath
#!/usr/bin/env bash

if [[ $# -lt 2 ]]; then
    echo "Insufficient arguments; expecting 2 arguments: source and target"
    exit 1
fi

src="$1"
shift
target="$1"
shift

# -m allows us to evaluate paths that aren't valid in the FS
# flexibility is nice : )
if readlink -m / > /dev/null 2>&1; then
    src=$(readlink -m $src)
    target=$(readlink -m $target)
else
    # if -m isn't supported, we settle for -f
    src=$(readlink -f $src)
    target=$(readlink -f $target)
fi

# if `realpath` has `relative-to`, just use that
if realpath --relative-to=/ $PWD > /dev/null 2>&1; then
    exec realpath --relative-to=$src $target 2> /dev/null
fi

common_part=$src
result=""

# calculate shared root/base
while [[ "${src}" != "${common_part}"* || "${target}" != "${common_part}"* ]]; do
    common_part="$(dirname $common_part)"
    result="../$result"
done

forward_part="${target#$common_part}"

if [[ ${result::((${#result}-1))} == '/' ]]; then
    result=${result::((${#result}-1))}
fi

result=$result$forward_part

if [[ -z "$result" ]]; then
    result '.'
fi

echo $result

#@@@@@@
# ~/.local/bin/split_var
#!/usr/bin/env bash

IFS=:
VAR=(${!1})

for V in ${VAR[@]}; do
    echo $V
done

#@@@@@@
# ~/.local/bin/varfind
#!/usr/bin/env bash

if [ $# -lt 2 ]; then
    echo You must provide a variable to search, as well as a file name to search for
    exit 1
fi

VAR=$1
shift

name_flag='-name'

if [ $1 = '-i' ]; then
    name_flag='-iname'
    shift
fi

PATHS=$(split_var $VAR)

if [[ $PATHS = "" ]]; then
    echo Empty variable, will search local directory.
fi

set -x
find $PATHS $name_flag $@ 2>/dev/null

#! @TODO Add filter lists
#find -L / -path /mnt -prune -o -path /proc -prune -o -path /dev -prune -o -path $HOME/.conan2 - prune -o -path /sys -prune -o $name_flag $@ -print 2>/dev/null

#@@@@@@
# ~/.local/bin/run_temp
#!/usr/bin/env bash

filename=__temp__.bash

echo '#!/usr/bin/env bash' >> $filename
nvim $filename

chmod +x $filename

./$filename
code=$?
rm $filename
exit $code
