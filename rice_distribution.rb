require 'pycall/import'

PyCall.exec('from scipy.stats import rice')
PyCall.exec('import numpy')

class RiceDistribution
  def initialize(data)
    @v = data.v
    @sigma = data.sigma
    @size = data.size
  end

  def rvs
    PyCall.eval("rice.rvs(#{v}, #{sigma}, size=#{size}).tolist()")
  end

  def pdf_arrange(values)
    PyCall.eval("numpy.arange(0, max(#{values}), 0.1).tolist()")
  end

  def pdf(arrange)
    PyCall.eval("rice.pdf(#{v}, #{sigma}, #{arrange}).tolist()")
  end

  def cdf
    PyCall.eval("rice.cdf(#{v}, #{sigma})")
  end

  def mean
    PyCall.eval("rice.mean(#{v}, #{sigma})")
  end

  def numpy_mean(values)
    PyCall.eval("numpy.mean(#{values})")
  end

  def var
    PyCall.eval("rice.var(#{v}, #{sigma})")
  end

  def numpy_var(values)
    PyCall.eval("numpy.var(#{values})")
  end

  private

  attr_reader :v
  attr_reader :sigma
  attr_reader :size
end
