### Testing Production Readiness of ML Products

* Why validating on the holdout set is not enough?
	- test data may != production data
		+ data drift
		+ sampling bias
			* e.g., data from live API requests vs. training data --- some API requests fail
		+ test data is but a sample and all edge cases are not included
	
	- expected behavior not explicitly captured
		+ robust to "small" changes in input
		+ robust to "noise"
		+ response to invalid inputs

	- testing systems than model performance narrowly defined

	- common problems with ML models
		+ learn a shallow representation
		+ predict confidently far from the observed data
		+ feedback loops

* Lessons from Software Testing

	* Get product requirements and write tests/metrics around each
		- e.g., fairness, speed, etc.

	* Unit tests
		- isolate a capability that is to be tested
		- e.g., invariance to typos
	
	* Robust boundary value testing
		- test across (observed and theoretical) min, max, and nominal
		- test response to invalid input variable types/values
			+ NLP - unicode than ascii, all NULLs, etc.
			+ test against "zero" information
	
	* Obvious errors
		- Compare to outputs of a dumb model and identify some of the "obvious" errors

	* Regression Testing
		* Identify cases where the new model fails when the original model did not
	
	* System Testing
		* e.g., Testing using the serving API (and infra.) rather than offline testing
		* also helps you test against 'real' data --- using the example from above (live API queries)

	* Testing code (to speed up and improve development and ensure quality) vs. Testing functionality  

* Example: Sentiment Analysis
	- Expectations
		+ Invariance to 'small' changes
			* Change in the named entity
			* Replacing a sentence with a semantically similar sentence
			* Having a few typos, etc.
			* Adding/Subtracting irrelevant neutral filler words
		+ Expected directional changes
			* Add a very short negative sentence -> sentiment should not become more positive
			* Negation

* Example: CV
	- Expectations
		+ Invariance to 'small' changes
			* Slight changes in resolution/contrast/etc.

* Example: self-driving
	- Expectations
		+ handling tail risk

* Testing ML Code
	- Deeper assertions for code quality: specific subcomputations of the algorithm are correct, e.g. that a specific part of an RNN was executed exactly once per element of the input sequence.
	- Cheap heuristics to find bugs in NN
		+ Loss decreases with training
		+ if a model can memorize training data, some of the things are working well
	- Data Flow Testing
		+ A variable that is defined but never used
		+ A variable that is used before it is defined
		+ A variable that is defined twice before it is used
	- Coverage-Guided Fuzzing: https://arxiv.org/pdf/1807.10875.pdf
		- choose recent inputs
		- mutate: for image add white noise, randomly delete/add/substitute characters for text
		- coverage: if nn is a new state
		- It is better to detect whether an activation vector is close to one that was observed previously. 

* Test Plan
	- Identify risks and test against those issues
		+ Privacy
			* Storing POST requests
				- https://cloud.google.com/speech-to-text/pricing
		+ SLA
		+ Data loss
		+ Latency
		+ Reliability
			* stress test against volume spikes

* What to log?
	+ Errors
	+ Warnings
	+ Changes to persistent data
	+ User interactions
	+ Calls w/ known risk of failure
	
* Prevention strategy
	* OS same as serving OS (Google)

* How not to die of testing
	- Pre-screening
		+ Use ML to figure out which tests to run, e.g., when code changes are 5 folders away, don't run all the tests
	- Run CI/CD when merging to master

### References

* https://arxiv.org/pdf/2005.04118.pdf
* https://www.youtube.com/watch?v=ytN72XLqzhk
* https://arxiv.org/pdf/2101.04840.pdf
* https://testing.googleblog.com/2011/09/10-minute-test-plan.html
* https://twitter.com/FeiziSoheil/status/1562476170117267459
