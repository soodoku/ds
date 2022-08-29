### How do I check if my model works?

* Cross-validation?

* Why cross-validation is not enough?
	- why test data may != production data
		+ data drift
		+ sampling bias
			* e.g., logged data for live API requests vs. training data. some API requests fail
		+ test data is but a sample and all edge cases are not included
	
	- expected behavior not explicitly captured
		+ robust to "small" changes in input
			* also used because we don't have an oracle
			* self-driving: weather and steering wheel angle
		+ robust to "noise"
		+ response to invalid inputs

	- common problems with ML models
		+ learn a shallow representation
		+ predictions far from data
		+ feedback loops
	
* Lessons from Software Testing

	* Offline testing vs. testing using the serving API (and infra.)

	* Get product requirements and write tests/metrics around each
		- e.g., fairness

	* Unit tests
		- isolate a capability that is to be tested
		- e.g., invariance to typos
	
	* Robust boundary value testing
		- test across (observed and theoretical) min, max, and nominal
		- test response to invalid input variable types/values
			+ NLP - unicode than ascii, all NULLs, etc.
			+ test against zero information
	
	* Obvious errors
		- Compare to outputs of a dumb model and identify some of the "obvious" errors

	* Regression Testing
		* Identify cases where the new model fails when the original model did not
	
	* System Testing

* Example: Sentiment Analysis
	- Expectations
		+ Invariance to 'small' changes
			* Change in named entity
			* Replacing sentence with a semantically similar sentence
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
		+ handling tail risk: simulation of edge cases

* State of the world
	* https://twitter.com/FeiziSoheil/status/1562476170117267459

* Testing ML Code
	- Deeper assertions for code quality: specific subcomputations of the algorithm are correct, e.g. that a specific part of an RNN was executed exactly once per element of the input sequence.
	- Loss decreases with training
	- Overfit --- if a model can memorize training data, things are working well	
	- Data Flowing Testing
		+ where variables receive values and points at which these values are used.
		+ A variable that is defined but never used (referenced)
		+ A variable that is used before it is defined
		+ A variable that is defined twice before it is used
	- Coverage-Guided Fuzzing: https://arxiv.org/pdf/1807.10875.pdf
		- choose recent inputs
		- mutate: for image add white noise, randomly delete/add/substitute characters for text
		- coverage: if nn is a new state
		- It is better to detect whether an activation vector is close to one that was observed previously. 

* Test Plan
	- Identify risks
		+ Privacy
		+ SLA
		+ Data loss

* What to log?
	+ Errors
	+ Warnings
	+ Changes to persistent data
	+ User interactions
	+ Calls w/ known risk of failure

* System testing
	+ 500/400 errors
	+ Latency
	+ Stress test against volume spikes

* Privacy
	* Storing POST requests
	* https://cloud.google.com/speech-to-text/pricing
	
* Prevention strategy
	* OS same as serving OS (Google)

* Poor man's solution
	* 

### References

* Paper: https://arxiv.org/pdf/2005.04118.pdf
* Video: https://www.youtube.com/watch?v=ytN72XLqzhk
* Paper: Robustness gym - https://arxiv.org/pdf/2101.04840.pdf
* https://testing.googleblog.com/2011/09/10-minute-test-plan.html