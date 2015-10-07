RSpec.describe ParamCleaner do
  context "transform_values_recursively!" do
    it "allows injecting a custom block to perform the rewrite" do
      hash1 = { some_key: "previous value" }
      hash2 = { some_key: "new value" }
      described_class.transform_values_recursively!(hash: hash1) do |_value|
        "new value"
      end
      expect(hash1).to eq(hash2)
    end

    it "works recursively" do
      hash1 = { some_key: "previous value", some_hash: { some_key: "previous value" } }
      hash2 = { some_key: "new value", some_hash: { some_key: "new value" } }
      described_class.transform_values_recursively!(hash: hash1) do |_value|
        "new value"
      end
      expect(hash1).to eq(hash2)
    end
  end

  context "call" do
    it "rewrites 'false' to false" do
      hash1 = { some_key: "false" }
      hash2 = { some_key: false }
      described_class.call(hash: hash1)
      expect(hash1).to eq(hash2)
    end

    it "rewrites 'true' to true" do
      hash1 = { some_key: "true" }
      hash2 = { some_key: true }
      described_class.call(hash: hash1)
      expect(hash1).to eq(hash2)
    end

    it "rewrites '' to nil" do
      hash1 = { some_key: "" }
      hash2 = { some_key: nil }
      described_class.call(hash: hash1)
      expect(hash1).to eq(hash2)
    end

    it "works recursively" do
      hash1 = { some_key: "", some_hash: { some_key: "" } }
      hash2 = { some_key: nil, some_hash: { some_key: nil } }
      described_class.call(hash: hash1)
      expect(hash1).to eq(hash2)
    end
  end
end
