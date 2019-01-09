
"""
A collection of utilities for easy benchmarking and testing of XCrypto
accelerated programs.
"""

import sys

class BaseTester(object):
    """
    Base class for "Testers". These objects are used to verify that
    the result of an algorithm or operation is correct.
    """

    def __init__(self):
        """
        Create a new empty tester object.
        """


    def test(inputs, outputs):
        """
        Take a tuple of inputs and the expected output(s), return True or
        False if the output is correct for the given input.
        """
        assert(type(inputs) == tuple)
        assert(type(outputs) == tuple)
        return True


class ResultsSetRecord(object):
    """
    Stores the inputs, outputs, performance metrics and correctness
    results for a single record of a ResultsSet
    """

    def __init__(self, inputs, outputs, metrics, correct):
        """
        Create a new record.
        """
        self.inputs     = inputs
        self.outputs    = outputs
        self.metrics    = metrics
        self.correct    = correct

    def __repr__(self):
        sys.stdout.write("%5s," self.correct)
        sys.stdout.write(",".join(self.inputs))
        sys.stdout.write(",".join(self.outputs))
        for k in self.metrics:
            sys.stdout.write(",%s=%s"%(k,self.metrics[k]))


class ResultsSet(object):
    """
    Container for sets of results output by the algorithm. This is where
    we collect things like runtime performance, instruction execution
    counts and correctness test results for each operation.
    """

    def __init__(self, testerClass = BaseTester()):
        """
        Create a new result set with the given testerClass object for
        checking the correctness of any results

        :param BaseTester testerClass:
        """

        self.tester  = testerClass
        self.results = []


    def addResult(inputs, outputs, metrics):
        """
        Add a new operation / result to the ResultSet.
        Check whether the result(s) are correct and store the associated
        performance metrics.
        """

        correct = self.tester.test(inputs,outputs)
        record  = ResultsSetRecord(inputs,outputs,metrics,correct)
        
        self.results.append(record)

    def printResults():
        """
        Print the results set to stdout
        """

        for r in self.results:
            print(r)
