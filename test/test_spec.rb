# frozen_string_literal: true

require "test_helper"
require "json"

class TestSpec < Minitest::Test
  spec = open_spec_file("spec.txt")

  spec.each do |testcase|
    next if testcase[:extensions].include?(:disabled)

    doc = CommonMarker.render_doc(testcase[:markdown], :DEFAULT, testcase[:extensions])

    define_method("test_to_html_example_#{testcase[:example]}") do
      actual = doc.to_html(:UNSAFE, testcase[:extensions]).rstrip
      assert_equal testcase[:html], actual, testcase[:markdown]
    end

    define_method("test_html_renderer_example_#{testcase[:example]}") do
      actual = HtmlRenderer.new(options: :UNSAFE, extensions: testcase[:extensions]).render(doc).rstrip
      assert_equal testcase[:html], actual, testcase[:markdown]
    end

    define_method("test_sourcepos_example_#{testcase[:example]}") do
      lhs = doc.to_html([:UNSAFE, :SOURCEPOS], testcase[:extensions]).rstrip
      rhs = HtmlRenderer.new(options: [:UNSAFE, :SOURCEPOS], extensions: testcase[:extensions]).render(doc).rstrip
      assert_equal lhs, rhs, testcase[:markdown]
    end
  end
end
