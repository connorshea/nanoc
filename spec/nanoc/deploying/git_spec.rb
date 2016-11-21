describe Nanoc::Deploying::Deployers::Git do
  let(:deployer) { described_class.new(output_dir, options) }

  subject { deployer.run }

  let(:output_dir) { 'output/' }
  let(:options) { {} }

  context 'output dir does not exist' do
    it 'raises' do
      # FIXME: Prefer Nanoc::Int::Errors::GenericTrivial
      # FIXME: Improve wording (build -> output, …)
      expect { subject }.to raise_error(
        RuntimeError, "output/ does not exist. Please build your site first.")
    end
  end

  context 'output dir exists' do
    # …
  end
end
