# Before running this, please make sure to activate and instantiate the
# tutorial-specific package environment, using this
# [`Project.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/ISL-lab-9/Project.toml) and
# [this `Manifest.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/ISL-lab-9/Manifest.toml), or by following
# [these](https://juliaai.github.io/DataScienceTutorials.jl/#learning_by_doing) detailed instructions.

# ## Getting started

using MLJ
import RDatasets: dataset
using PrettyPrinting
using Random

# We start by generating a 2D cloud of points

Random.seed!(3203)
X = randn(20, 2)
y = vcat(-ones(10), ones(10))

# which we can visualise

using PyPlot
figure(figsize=(8,6))

ym1 = y .== -1
ym2 = .!ym1
plot(X[ym1, 1], X[ym1, 2], ls="none", marker="o")
plot(X[ym2, 1], X[ym2, 2], ls="none", marker="x")

# \figalt{Toy points}{ISL-lab-9-g1.svg}

# let's wrap the data as a table:

X = MLJ.table(X)
y = categorical(y);

# and fit a SVM classifier

SVC = @load SVC pkg=LIBSVM

svc_mdl = SVC()
svc = machine(svc_mdl, X, y)

fit!(svc);

# As usual we can check how it performs

ypred = MLJ.predict(svc, X)
misclassification_rate(ypred, y)

# Not bad.

# ### Basic tuning

# As usual we could tune the model, for instance the penalty encoding the tradeoff between margin width and misclassification:

rc = range(svc_mdl, :cost, lower=0.1, upper=5)
tm = TunedModel(model=svc_mdl, ranges=[rc], tuning=Grid(resolution=10),
                resampling=CV(nfolds=3, rng=33), measure=misclassification_rate)
mtm = machine(tm, X, y)

fit!(mtm)

ypred = MLJ.predict(mtm, X)
misclassification_rate(ypred, y)

# You could also change the kernel etc.

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

