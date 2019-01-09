
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
    
    def golden(self,inputs):
        """
        Return the golden/trusted set of outputs given the inputs
        """
        return []

    def test(self,inputs, outputs):
        """
        Take a tuple of inputs and the expected output(s), return True or
        False if the output is correct for the given input.
        """
        results = self.golden(inputs)

        for i in range(0, len(outputs)):
            if(outputs[i] != results[i]):
                return False
        return True

class MPNAddTester(BaseTester):
    """
    Tester class for multi-precision add operations
    """

    def golden(self,inputs):
        lhs, rhs = inputs
        return     [lhs + rhs]


class MPNSubTester(BaseTester):
    """
    Tester class for multi-precision subtract operations
    """

    def golden(self,inputs):
        lhs, rhs = inputs
        return     [lhs - rhs]

class MPNMulTester(BaseTester):
    """
    Tester class for multi-precision multiply operations
    """

    def golden(self,inputs):
        lhs, rhs = inputs
        return     [lhs * rhs]


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
        tr  = "%5s," % self.correct
        tr +=",".join([str(s) for s in self.inputs ])
        tr +=",".join([str(s) for s in self.outputs])
        for k in self.metrics:
            tr += ",%s=%s"%(k,self.metrics[k])
        return tr


class ResultsSet(object):
    """
    Container for sets of results output by the algorithm. This is where
    we collect things like runtime performance, instruction execution
    counts and correctness test results for each operation.
    """

    def __init__(self, name, testerClass = BaseTester()):
        """
        Create a new result set with the given testerClass object for
        checking the correctness of any results

        :param BaseTester testerClass:
        """
        
        self.name    = name
        self.tester  = testerClass
        self.results = []

    def addRecord(self,rec):
        """
        Add a new record to the results set.
        """
        rec.correct = self.tester.test(rec.inputs,rec.outputs)
        self.results.append(rec)

    def addResult(inputs, outputs, metrics):
        """
        Add a new operation / result to the ResultSet.
        Check whether the result(s) are correct and store the associated
        performance metrics.
        """

        correct = self.tester.test(inputs,outputs)
        record  = ResultsSetRecord(inputs,outputs,metrics,correct)
        
        self.results.append(record)
    
    def allCorrect(self):
        
        passed = True
        for r in self.results:
            passed = passed and r.correct
            if(not passed):
                break
        return passed

    def printResults(self):
        """
        Print the results set to stdout
        """

        for r in self.results:
            print(r)
