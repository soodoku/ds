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
		+ robust to "noise"
		+ response to invalid inputs

	- common problems with ML models
		+ learn a shallow representation
		+ predictions far from data

* Lessons from Software Testing

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

* Testing ML Code
	- Data Flowing Testing
		+ where variables receive values and points at which these values are used.
		+ A variable that is defined but never used (referenced)
		+ A variable that is used before it is defined
		+ A variable that is defined twice before it is used

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

### References

* Paper: https://arxiv.org/pdf/2005.04118.pdf
* Video: https://www.youtube.com/watch?v=ytN72XLqzhk
* Paper: Robustness gym - https://arxiv.org/pdf/2101.04840.pdf
* https://testing.googleblog.com/2011/09/10-minute-test-plan.html