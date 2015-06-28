import os
import codecs
import shutil
import re
import data_format_classes

from html.parser import HTMLParser

questions = []
filename = 'test1.txt'
with open(filename, encoding='utf8') as f:
	data = f.read()
	bulks = data.split('\n\n')
	pattern = re.compile('(.+)A\.(.+)B\.(.+)C\.(.+)D\.(.+)E\.(.+)', re.DOTALL)
	for bulk in bulks:
		match = pattern.match(bulk)		
		if match:
			question = data_format_classes.Question()
			question.question = match.group(1).lstrip().rstrip()
			question.topics = ['General']
			for i in range(2, 7):
				answer = data_format_classes.Answer()
				answerStr = match.group(i)
				if ' (x)' in answerStr:
					answerStr = answerStr.replace(' (x)', '')
					answer.correct = True					
				answer.answer = answerStr.lstrip().rstrip()
				question.answers.append(answer)
			questions.append(question)


	# print(data.encode('utf8'))
	# print(f.read().encode('utf8'))
# files = [f for f in os.listdir('.') if os.path.isfile(f)]
# for filename in files:
# 	if '.html' in filename:
# 		print(filename)
# 		with open(filename, encoding='utf8') as f:
# 			spell = Spell(filename.split('.')[0])
# 			parser = SpellHTMLParser(spell)
# 			parser.feed(f.read())
# 			spells.append(parser.spell)

with codecs.open('questions1.json', 'w', 'utf8') as f:
	f.write('{ "questions": [\n')	
	delimiter = ''
	for question in questions:
		f.write(delimiter)	
		f.write(question.toJson())
		delimiter = ', '
	f.write('\n]}')