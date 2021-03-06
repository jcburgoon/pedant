################################################################################
# Copyright (c) 2011-2014, Tenable Network Security
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################

class TestContainsNoTabs < Test::Unit::TestCase
  include Pedant::Test

  def test_none
    check(
      :pass,
      :CheckContainsNoTabs,
      %q||
    )
  end

  def test_one
    check(
      :warn,
      :CheckContainsNoTabs,
      %Q|\t|
    )
  end

  def test_line_squashing
    assert_equal(
      Pedant::CheckContainsNoTabs.chunk_while([1, 2, 3, 5, 6]) { |i, j| i + 1 == j },
      [[1, 2, 3], [5, 6]]
    )

    assert_equal(
      Pedant::CheckContainsNoTabs.chunk_while([1, 3, 5]) { |i, j| i + 1 == j },
      [[1], [3], [5]]
    )

    assert_equal(
      Pedant::CheckContainsNoTabs.chunk_while([1]) { |i, j| i + 1 == j },
      [[1]]
    )

    assert_equal(
      Pedant::CheckContainsNoTabs.chunk_while([]) { |i, j| i + 1 == j },
      [[]]
    )
  end
end
