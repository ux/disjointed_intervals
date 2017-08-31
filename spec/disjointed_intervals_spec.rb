require_relative '../lib/disjointed_intervals'

RSpec.describe DisjointedIntervals do
  subject(:disjointed_intervals) { described_class.new(initial_intervals) }

  let(:initial_intervals) { [] }
  let(:intervals) { disjointed_intervals.intervals }

  describe '#intervals' do
    subject { intervals }

    let(:initial_intervals) { [[1, 2], [3, 4], [7, 8]] }

    it { is_expected.to eq initial_intervals }
  end

  shared_examples 'does not accept invalid from-to arguments' do
    context 'when from is not specified' do
      let(:from_to) { [nil, 20] }

      it { expect { subject }.to raise_error ArgumentError }
    end

    context 'when to is not specified' do
      let(:from_to) { [10, nil] }

      it { expect { subject }.to raise_error ArgumentError }
    end

    context 'when from is not lesser than to' do
      let(:from_to) { [10, 10] }

      it { expect { subject }.to raise_error ArgumentError }
    end
  end

  describe '#add' do
    subject { disjointed_intervals.add(*from_to) }

    it_behaves_like 'does not accept invalid from-to arguments'

    context 'when from-to is within interval' do
      let(:initial_intervals) { [[5, 10]] }
      let(:from_to) { [6, 7] }

      it { is_expected.to eq [[5, 10]] }
    end

    context 'when from-to is the same as interval' do
      let(:initial_intervals) { [[5, 10]] }
      let(:from_to) { [5, 10] }

      it { is_expected.to eq [[5, 10]] }
    end

    context 'when from-to covers interval' do
      let(:initial_intervals) { [[5, 10], [12, 13]] }
      let(:from_to) { [4, 11] }

      it { is_expected.to eq [[4, 11], [12, 13]] }
    end

    context 'when from-to touches interval from the left' do
      let(:initial_intervals) { [[5, 10]] }
      let(:from_to) { [3, 5] }

      it { is_expected.to eq [[3, 10]] }
    end

    context 'when from-to touches interval from the right' do
      let(:initial_intervals) { [[5, 10]] }
      let(:from_to) { [10, 15] }

      it { is_expected.to eq [[5, 15]] }
    end

    context 'when from-to intersects single interval' do
      let(:initial_intervals) { [[5, 10], [12, 13]] }
      let(:from_to) { [7, 11] }

      it { is_expected.to eq [[5, 11], [12, 13]] }
    end

    context 'when from-to intersects two intervals' do
      let(:initial_intervals) { [[5, 10], [12, 15]] }
      let(:from_to) { [8, 13] }

      it { is_expected.to eq [[5, 15]] }
    end

    context 'when from-to covers first interval and intersects second' do
      let(:initial_intervals) { [[5, 10], [12, 15]] }
      let(:from_to) { [3, 13] }

      it { is_expected.to eq [[3, 15]] }
    end

    context 'when from-to intersects first interval and covers second' do
      let(:initial_intervals) { [[5, 10], [12, 15]] }
      let(:from_to) { [8, 18] }

      it { is_expected.to eq [[5, 18]] }
    end

    context 'when from-to is between two intervals' do
      let(:initial_intervals) { [[5, 10], [15, 20]] }
      let(:from_to) { [12, 13] }

      it { is_expected.to eq [[5, 10], [12, 13], [15, 20]] }
    end

    context 'when from-to is before first interval' do
      let(:initial_intervals) { [[5, 10]] }
      let(:from_to) { [0, 4] }

      it { is_expected.to eq [[0, 4], [5, 10]] }
    end

    context 'when from-to is after last interval' do
      let(:initial_intervals) { [[5, 10]] }
      let(:from_to) { [15, 20] }

      it { is_expected.to eq [[5, 10], [15, 20]] }
    end
  end

  describe '#remove' do
    subject { disjointed_intervals.remove(*from_to) }

    it_behaves_like 'does not accept invalid from-to arguments'

    context 'when from-to is within interval' do
      let(:initial_intervals) { [[5, 10]] }
      let(:from_to) { [6, 7] }

      it { is_expected.to eq [[5, 6], [7, 10]] }
    end

    context 'when from-to is the same as interval' do
      let(:initial_intervals) { [[5, 10]] }
      let(:from_to) { [5, 10] }

      it { is_expected.to eq [] }
    end

    context 'when from-to covers interval' do
      let(:initial_intervals) { [[5, 10], [12, 13]] }
      let(:from_to) { [4, 11] }

      it { is_expected.to eq [[12, 13]] }
    end

    context 'when from-to touches interval from the left' do
      let(:initial_intervals) { [[5, 10]] }
      let(:from_to) { [3, 5] }

      it { is_expected.to eq [[5, 10]] }
    end

    context 'when from-to touches interval from the right' do
      let(:initial_intervals) { [[5, 10]] }
      let(:from_to) { [10, 15] }

      it { is_expected.to eq [[5, 10]] }
    end

    context 'when from-to intersects single interval' do
      let(:initial_intervals) { [[5, 10], [12, 13]] }
      let(:from_to) { [7, 11] }

      it { is_expected.to eq [[5, 7], [12, 13]] }
    end

    context 'when from-to intersects two intervals' do
      let(:initial_intervals) { [[5, 10], [12, 15]] }
      let(:from_to) { [8, 13] }

      it { is_expected.to eq [[5, 8], [13, 15]] }
    end

    context 'when from-to covers first interval and intersects second' do
      let(:initial_intervals) { [[5, 10], [12, 15]] }
      let(:from_to) { [3, 13] }

      it { is_expected.to eq [[13, 15]] }
    end

    context 'when from-to intersects first interval and covers second' do
      let(:initial_intervals) { [[5, 10], [12, 15]] }
      let(:from_to) { [8, 18] }

      it { is_expected.to eq [[5, 8]] }
    end

    context 'when from-to is between two intervals' do
      let(:initial_intervals) { [[5, 10], [15, 20]] }
      let(:from_to) { [12, 13] }

      it { is_expected.to eq [[5, 10], [15, 20]] }
    end

    context 'when from-to is before first interval' do
      let(:initial_intervals) { [[5, 10]] }
      let(:from_to) { [0, 4] }

      it { is_expected.to eq [[5, 10]] }
    end

    context 'when from-to is after last interval' do
      let(:initial_intervals) { [[5, 10]] }
      let(:from_to) { [15, 20] }

      it { is_expected.to eq [[5, 10]] }
    end
  end
end
