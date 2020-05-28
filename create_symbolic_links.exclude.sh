#!bin/sh
link () { 
	echo "This utility will symlink the files in this repo to the home directory" 	
	echo "Proceed? (y/n)" 	
	read resp 	
	# TODO - regex here? 	
	if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then 		
		for directory in $( ls -A | grep -vE '\.exclude*|\.git$|\.gitignore|\.gitexcludes|.*.md' ) ; do 			
		    echo " Directory is $directory"
		    			
		    for file in $( ls -A ./$directory | grep -vE '\.exclude*|\.git$|\.gitignore|.*.md' ) ; do 			
 			ln -sv "$PWD/$directory/$file" "$HOME" 		
		done
		done
		# TODO: source files here? 		
		echo "Symlinking complete" 	
	else 		
		echo "Symlinking cancelled by user" 		
		return 1 	
	fi 
}
link

