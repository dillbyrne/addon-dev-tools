#! /usr/bin/env python
# -*- coding: utf-8 -*-

import goslate


#TODO 
# add threading
# add option parsing
# add error checking


def translate_file(ifilename,ofilename,tlang):
	
	gs = goslate.Goslate()	
	infile = file(ifilename,'r')
	outfile = file(ofilename,'a')

	for line in infile:
		
		#copy comments directly
		if line[:1] == '#' or line == "\n":
			outfile.write(line)
		else:
			#split line on '='
			sline = line.split('=',1)
			#translate words after the =
			translation = gs.translate(sline[1],tlang)	
			# rejoin line before = and newly tranlated line
			# encode to utf 8 and write to locale file
			outfile.write(sline[0] + "= "+ translation.encode('utf-8')+'\n')

	outfile.close()
	infile.close()


def bulk_translate():

	langs = raw_input('Enter the locales to translate to separated by a comma: ').split(",")
	infile = raw_input('Enter source translation file : ')
	outdir = raw_input ('Enter the destination directory :')

	for l in langs:
		print "translating to "+ l
		translate_file(infile,outdir+l+".properties",l)


bulk_translate()
