# Release page preprocessing
# - Generates additional variables for use in templates
# - Converts canonical ticket and man page references to Markdown links

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
        tarball = site_data['tarball']
        baseurl = tarball['baseurl']
        if snapshot then
          dir = 'testing'
        else
          dir = "#{project}-#{series}"
        end
        name = "#{project}-#{slug}"
        ext = tarball['fileext']
        tarball = "#{baseurl}/#{dir}/#{name}.#{ext}"

        # Add new variables to page
        data['title'] = title
        data['series'] = series
        data['tarball'] = tarball

        # Convert ticket references to links
        baseurl = site_data['ticket']['baseurl']
        page.content = page.content.gsub(
          /\(#([0-9]+)\)/, '([#\1]('"#{baseurl}"'/\1))')

        # Convert man page references to links
        baseurl = site_data['manual']['baseurl']
        page.content = page.content.gsub(
          /`(rpm[-\.[:alnum:]]*|gendiff)\(([1-8])\)`/,
          '[\1(\2)]('"#{baseurl}"'/\1.\2)')
      end
    end
  end
end
