RSCRIPT ?= Rscript

.PHONY: check slides ci-docker

check:
	$(RSCRIPT) tests/check_math.R

slides:
	$(RSCRIPT) -e 'for (f in Sys.glob("*/*.Rmd")) rmarkdown::render(f, envir = new.env(), quiet = TRUE)'
	$(RSCRIPT) -e 'knitr::knit("01_stat/learning_from_data.Rmd", output = "01_stat/learning_from_data.md", quiet = TRUE)'

ci-docker:
	docker run --rm -v "$(CURDIR):/work:ro" -w /work r-base:latest \
		Rscript -e 'install.packages("knitr", repos="https://cloud.r-project.org"); source("tests/check_math.R")'
