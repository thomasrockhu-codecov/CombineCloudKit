#!/usr/bin/env bash

ddp="$HOME/Library/Developer/Xcode/DerivedData"

ft_xcodellvm="1"
ft_xcodeplist="0"

b="\033[0;36m"
g="\033[0;32m"
r="\033[0;31m"
e="\033[0;90m"
y="\033[0;33m"
x="\033[0m"

say() {
  echo -e "$1"
}

swiftcov() {
  _dir=$(dirname "$1" | sed 's/\(Build\).*/\1/g')
  for _type in app framework xctest
  do
    find "$_dir" -name "*.$_type" | while read -r f
    do
      _proj=${f##*/}
      _proj=${_proj%."$_type"}
      if [ "$2" = "" ] || [ "$(echo "$_proj" | grep -i "$2")" != "" ];
      then
        say "    $g+$x Building reports for $_proj $_type"
        dest=$([ -f "$f/$_proj" ] && echo "$f/$_proj" || echo "$f/Contents/MacOS/$_proj")
        say "1   $dest"
        # shellcheck disable=SC2001
        _proj_name=$(echo "$_proj" | sed -e 's/[[:space:]]//g')
        say "2    $_proj"
        say "3     $_proj_name"
        say "4      $_type"

        _proj_name=$(echo "$_proj" | sed -e 's/[[:space:]]//g')
        # shellcheck disable=SC2086
        xcrun llvm-cov show -instr-profile "$1" "$dest" > "$_proj_name.$_type.coverage.txt" \
         || say "    ${r}x>${x} llvm-cov failed to produce results for $dest"
        say "meow"
        ls
        say "$_proj_name.$_type.coverage.txt"
        cat "$_proj_name.$_type.coverage.txt"
      fi
    done
  done
}

 # Swift Coverage
if [ "$ft_xcodellvm" = "1" ] && [ -d "$ddp" ];
then
	say "${e}==>${x} Processing Xcode reports via llvm-cov"
	say "    DerivedData folder: $ddp"
	profdata_files=$(find "$ddp" -name '*.profdata' 2>/dev/null || echo '')
	if [ "$profdata_files" != "" ];
	then
		# xcode via profdata
		if [ "$xp" = "" ];
		then
			# xp=$(xcodebuild -showBuildSettings 2>/dev/null | grep -i "^\s*PRODUCT_NAME" | sed -e 's/.*= \(.*\)/\1/')
			# say " ${e}->${x} Speed up Xcode processing by adding ${e}-J '$xp'${x}"
			say "    ${g}hint${x} Speed up Swift processing by using use ${g}-J 'AppName'${x} (regexp accepted)"
			say "    ${g}hint${x} This will remove Pods/ from your report. Also ${b}https://docs.codecov.io/docs/ignoring-paths${x}"
		fi
		while read -r profdata;
		do
			if [ "$profdata" != "" ];
			then
				swiftcov "$profdata" "$xp"
			fi
		done <<< "$profdata_files"
	else
		say "    ${e}->${x} No Swift coverage found"
	fi
fi

if [ "$ft_xcodeplist" = "1" ] && [ -d "$ddp" ];
then
	say "${e}==>${x} Processing Xcode plists"
	plists_files=$(find "$ddp" -name '*.xccoverage' 2>/dev/null || echo '')
	if [ "$plists_files" != "" ];
	then
		while read -r plist;
		do
			if [ "$plist" != "" ];
			then
				say "    ${g}Found${x} plist file at $plist"
				plutil -convert xml1 -o "$(basename "$plist").plist" -- "$plist"
			fi
		done <<< "$plists_files"
	fi
fi
