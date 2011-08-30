require File.dirname(__FILE__) + '/spec_helper'

class ModelWithCreateCallback < ActiveRecord::Base
  before_create :store_callback

  def store_callback
    "something"
  end
end

describe "ActiveRecord::Base.record_callbacks {}" do
  it "records the name of an executed callback" do
    ActiveRecord::Base.record_callbacks do
      ModelWithCreateCallback.create!
    end
    CallbackHunter.callbacks.first.method.should == :store_callback
  end

  it "records the kind of an executed callback" do
    ActiveRecord::Base.record_callbacks do
      ModelWithCreateCallback.create!
    end
    CallbackHunter.callbacks.first.kind.should == :before_create
  end

  it "records the target of an executed callback" do
    model = ActiveRecord::Base.record_callbacks do
      ModelWithCreateCallback.create!
    end
    model.should be_a(ModelWithCreateCallback)
    CallbackHunter.callbacks.first.target.should be(model)
  end

  it "records the benchmark of an executed callback" do
    ActiveRecord::Base.record_callbacks do
      ModelWithCreateCallback.create!
    end
    CallbackHunter.callbacks.first.benchmark.utime.should be_present
  end
end
