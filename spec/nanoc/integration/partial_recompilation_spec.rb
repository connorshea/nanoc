describe 'Partial recompilation', site: true, stdio: true do
  before do
    File.write('content/foo.md', "---\ntitle: hello\n---\n\nfoo")
    File.write('content/bar.md', '<%= @items["/foo.*"].compiled_content %>')

    File.write('lib/default.rb', <<EOS)
Nanoc::Filter.define(:crash) do |content, params|
  raise 'boom'
end
EOS

    File.write('Rules', <<EOS)
compile '/foo.*' do
  write '/foo.html'
end

compile '/bar.*' do
  filter :erb
  filter :crash
  write '/bar.html'
end
EOS
  end

  example do
    expect(File.file?('output/foo.html')).not_to be
    expect(File.file?('output/bar.html')).not_to be

    expect { Nanoc::CLI.run(%w(compile --verbose)) rescue nil }
      .to output(/create.*output\/foo\.html/).to_stdout

    expect(File.file?('output/foo.html')).to be
    expect(File.file?('output/bar.html')).not_to be

    expect { Nanoc::CLI.run(%w(show-data --no-color)) }.to(
      output(/^item \/foo\.md, rep default:\n  is not outdated/).to_stdout,
    )
  end
end
