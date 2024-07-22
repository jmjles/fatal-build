"""
    Plugin for ResolveURL
    Copyright (C) 2024 gujal

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
"""

import json
from six.moves import urllib_parse
from resolveurl.lib import helpers
from resolveurl import common
from resolveurl.resolver import ResolveUrl, ResolverError


class BrBeastResolver(ResolveUrl):
    name = 'BrBeast'
    domains = ['brbeast.com']
    pattern = r'(?://|\.)(brbeast\.com)/(?:video/|player/index.php\?data=)([0-9a-zA-Z-]+)'

    def get_media_url(self, host, media_id):
        web_url = self.get_url(host, media_id)
        rurl = urllib_parse.urljoin(web_url, '/')
        headers = {'User-Agent': common.FF_USER_AGENT,
                   'Origin': rurl[:-1],
                   'X-Requested-With': 'XMLHttpRequest'}
        data = {'hash': media_id, 'r': ''}
        html = self.net.http_POST(web_url, form_data=data, headers=headers).content
        r = json.loads(html)
        if r:
            source = r.get('securedLink')
            if source:
                headers.pop('X-Requested-With')
                return source + helpers.append_headers(headers)
        raise ResolverError('Video Link Not Found')

    def get_url(self, host, media_id):
        return self._default_get_url(host, media_id, 'https://{host}/player/index.php?data={media_id}&do=getVideo')
