import logging

# Logger objects for internal use
gen_log = logging.getLogger("expression.general")
gen_log.setLevel(logging.DEBUG)

# Set file handler
fileHandler = logging.FileHandler("runtime.log")
formatter1 = logging.Formatter('%(name)-12s %(asctime)s: %(levelname)-8s %(message)s')
fileHandler.setFormatter(formatter1)
fileHandler.setLevel(logging.DEBUG)
gen_log.addHandler(fileHandler)

#set console handler
consoleHandler = logging.StreamHandler()
formatter2 = logging.Formatter('%(name)-12s : %(levelname)-8s %(message)s')
consoleHandler.setFormatter(formatter2)
consoleHandler.setLevel(logging.INFO)
gen_log.addHandler(consoleHandler)
