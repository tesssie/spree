module Spree
  module Stock
    class Prioritizer
      attr_reader :packages

      def initialize(packages, adjuster_class=Adjuster)
        @packages = packages
        @adjuster_class = adjuster_class
        @adjusters = Hash.new
      end

      def prioritized_packages
        sort_packages
        adjust_packages
        prune_packages
        packages
      end

      private

      def adjust_packages
        packages.each do |package|
          package.contents.each do |item|
            adjuster = find_adjuster(item) || build_adjuster(item, package)
          end
        end
      end

      def build_adjuster(item, package)
        @adjusters[item.variant] = @adjuster_class.new(item.inventory_unit, item.state, package)
      end

      def find_adjuster(item)
        @adjusters[item.variant]
      end

      def sort_packages
        # order packages by preferred stock_locations
      end

      def prune_packages
        packages.reject! { |pkg| pkg.empty? }
      end
    end
  end
end
