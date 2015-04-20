#! /bin/bash

# FoxCatcher - a bulk firefox downloader

# Downloads multiple versions of firefox with different locales
# for testing translations and accept language headers

# dillbyrne GNU GPL v3


catch_foxes()
{
	declare -a LANGS=( $(echo $3 | sed -e 's/,/ /g') )

	for L in "${LANGS[@]}"
	do
		# Check the version has been downloaded already
		# Skip it if so
		if [ ! -e "foxes/.browsers/firefox-$1-$L" ]
		then
			# Download the specified browser
			echo "Downloading firefox $1-$L"
			curl -s https://download-installer.cdn.mozilla.net/pub/firefox/releases/$1/$2/$L/firefox-$1.tar.bz2 > foxes/.browsers/$1-$L.tar.bz2

			# Extract to subfolder and delete tar file
			echo "Extracting tar file to ./browsers/firefox-$1-$L"
			tar -xf foxes/.browsers/$1-$L.tar.bz2 --transform "s/firefox/firefox-$1-$L/"
			mv firefox-$1-$L foxes/.browsers/
			rm foxes/.browsers/$1-$L.tar.bz2

			# Make symlinks. Lead filenames with Luage code for better tab completion
			echo "Making symbolic link"
			ln -s .browsers/firefox-$1-$L/firefox ./foxes/$L-$1
			echo

		else
			echo "Skipping firefox-$1-$L"
			echo
		fi

	done

	echo "Done"
}


setup_dirs()
{
	# Setup Directories
	if [ ! -d foxes/.browsers ]
	then
		mkdir -p foxes/.browsers
	fi

}

show_locales()
{
	echo
	echo "-----------------------------------------------------------"
	echo "             FoxCatcher - Available Locales"
	echo "-----------------------------------------------------------"
	echo
	echo "ach af an ar as ast az"
	echo "be bg bn-BD bn-IN br bs"
	echo "ca cs cy da de dsb"
	echo "el en-GB en-US en-ZA eo es-AR es-CL es-ES es-MX et eu"
	echo "fa ff fi fr fy-NL"
	echo "ga-IE gd gl gu-IN he hi-IN hr hsb hu hy-AM"
	echo "id is it ja kk km kn ko lij lt lv"
	echo "mai mk ml mr ms nb-NO nl nn-NO"
	echo "or pa-IN pl pt-BR pt-PT rm ro ru"
	echo "si sk sl son sq sr sv-SE ta te th tr"
	echo "uk uz vi xh zh-CN zh-TW"
	echo
	echo "-----------------------------------------------------------"
	echo
}

usage()
{
	echo
	echo "-----------------------------------------------------------"
	echo "                        FoxCatcher"
	echo "-----------------------------------------------------------"
	echo
	echo
	echo "Usage: foxcatcher -l locales -v version -p platform"
	echo
	echo -l locales : a comma separated list of locales
	echo
	echo -v version : the version of firefox to download
	echo
	echo -p platform : the platfrom to download download for
	echo
	echo -c : show available locale codes
	echo
	echo "e.g: ./foxcatcher -l ru,be,fr-FR -v 37.0.1 -p linux-x86_64"
	echo
	echo
	echo "-----------------------------------------------------------"
	echo
}

check_args()
{
	if [[ "$1" == "" || "$2" == "" || "$3" == "" ]]
	then
		usage
		exit 1
	fi
}

 main()
{
	local OPTIND=1	#Option Index

	local version=""
	local locales=""
	local platform=""

	while getopts "h?:l:v:p:c" opt;
	do
		case "$opt" in
		h|\?)
			usage
			exit 0
			;;
		l)  locales=$OPTARG
			;;
		v)  version=$OPTARG
			;;
		p)  platform=$OPTARG
			;;
		c)  show_locales
			exit 0
			;;
		esac
	done

	shift $((OPTIND-1))

	check_args $version $platform $locales
	setup_dirs
	catch_foxes $version $platform $locales
}

main $*
