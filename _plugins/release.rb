# Generate additional variables in release pages
module Releases
  class Generator < Jekyll::Generator
    def generate(site)
      site_data = site.data['release']
      site.collections['releases'].docs.each do |page|
        data = page.data

        project = data['project']
        version = data['version']
        snapshot = data['snapshot']
        slug = data['slug']

        # Construct title
        title = "#{project.upcase} #{version}"
        if snapshot then
          title += " #{snapshot.upcase}"
        end

        # Construct version series (e.g. 4.19.x)
        series = version.gsub(/^([0-9]+\.[0-9]+)\..+$/, '\1.x')

        # Construct tarball URL
        baseurl = site_data['baseurl']
        if snapshot then
          dir = 'testing'
        else
          dir = "#{project}-#{series}"
        end
        name = "#{project}-#{slug}"
        ext = site_data['fileext']
        tarball = "#{baseurl}/#{dir}/#{name}.#{ext}"

        # Add new variables to page
        data['layout'] = 'release'
        data['title'] = title
        data['series'] = series
        data['tarball'] = tarball
      end
    end
  end
end
