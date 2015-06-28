class Question:
	def __init__(self):
		self.question = ''
		self.multiple = False
		self.answers = []
		self.topics = []
		self.difficulty = 1
	def __str__(self):
		return self.toJson() + '\n'
	def toJson(self):
		return """ {
			"question": "%s",
			"multiple": %s,
			"answers": %s,
			"topics": %s,
			"difficulty": %s
		}
		""" % (self.question.replace('\n', '\\n'), str(self.multiple).lower(), '[' + ', '.join((answer.toJson() for answer in self.answers)) + ']',
			   '[' + ', '.join(('"' + str(topic) + '"' for topic in self.topics)) + ']', self.difficulty)

class Answer:
	def __init__(self):
		self.answer = ''
		self.correct = False
		self.description = 'Description is not given'
	def __str__(self):
		return self.answer + '\n'
	def toJson(self):
		return """ {
			"answer": "%s",
			"correct": %s,
			"description": "%s"
		}
		""" % (self.answer.replace('\n', '\\n'), str(self.correct).lower(), self.description)
