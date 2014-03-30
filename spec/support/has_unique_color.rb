shared_examples 'has unique color' do
  describe '.colors' do
    it 'returns a list of available colors' do
      expect(described_class.colors).to have_at_least(1).colors
    end

    it 'returns valid hex colors' do
      expect(described_class.colors.first).to match(/^#(\d|([a-f]|[A-F])){3,6}$/)
    end
  end



  describe '#color' do
    it 'is always set' do
      object = FactoryGirl.create(described_class.name.downcase.to_sym)
      expect(described_class.colors).to include object.color
    end

    it 'is unique relative to the budget scope' do
      old_objects = []
      2.times { old_objects << FactoryGirl.create(described_class.name.downcase.to_sym) }
      new_object = FactoryGirl.create(described_class.name.downcase.to_sym)

      expect(old_objects.map(&:color)).not_to include(new_object.color)
    end

    it 'is not changed when saving' do
      object = FactoryGirl.create(described_class.name.downcase.to_sym)
      color = object.color
      object.save
      expect(object.color).to eql color
    end

  end
end