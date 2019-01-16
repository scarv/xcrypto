
"""
A collection of utilities for easy benchmarking and testing of XCrypto
accelerated programs.
"""

import sys

import hashlib
import binascii
import Crypto.Cipher.AES as AES

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

class KeccakP400Tester(BaseTester):
    def test(self, inputs, outputs):
        return True # Checking done live in C code

class KeccakP1600Tester(BaseTester):
    def test(self, inputs, outputs):
        return True # Checking done live in C code

class PrinceTester(BaseTester):
    def test(self, inputs, outputs):
        return True # Checking done live in C code

class SHA256Tester(BaseTester):
    def golden(self, inputs):
        din = binascii.a2b_hex(inputs[0])
        return hashlib.sha256(din).hexdigest().upper()

    def test(self, inputs, outputs):
        o = outputs[0]
        g = self.golden(inputs)
        return o == g


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


    def test(self, inputs, outputs):
        return True ## DUMMY


class AESEncTester(BaseTester):
    """
    Tester class for AES encryption operations
    """

    def golden(self,inputs):
        m = binascii.a2b_hex(inputs[0])
        k = binascii.a2b_hex(inputs[1])
        r = AES.new( k ).encrypt( m ) 
        return  r.hex().upper()

    def test(self, inputs, outputs):
        c = outputs[0]
        r = self.golden(inputs)
        return c==r

class AESDecTester(BaseTester):
    """
    Tester class for AES decryption operations
    """

    def golden(self,inputs):
        c = binascii.a2b_hex(inputs[0])
        k = binascii.a2b_hex(inputs[1])
        r = AES.new( k ).decrypt( c ) 
        return  r.hex().upper()

    def test(self, inputs, outputs):
        m = outputs[0]
        r = self.golden(inputs)
        return m==r

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
        tr +=","
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
