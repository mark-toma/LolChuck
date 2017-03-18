function varargout = lolChuck(opts)
% lolChuck  Prints a Chuck Norris joke to the command window
%
%   Display jokes fetched from the Internet Chuck Norris Database (ICNDb).
%   See the links below for more information about the ICNDb and software
%   dependencies (JSONlab).
%
%
% Inputs:
%
%   opts (optional):
%     Struct with fields specifying options to API parameters
%     opts.firstName - First name in joke (replaces 'Chuck')
%     opts.lastName  - Last name in joke (replaces 'Norris')
%
% Usage:
%
%   lolChuck() - Prints a Chuck Norris joke to the command window
%
%   val = lolChuck() - Additionally returns the joke data to the workspace
%
% Examples:
%
%   >> lolChuck
%
%   Chuck Norris is the only person to ever win a staring contest against
%   Ray Charles and Stevie Wonder.
%
%   >> val = lolChuck
%
%   Wo hu cang long. The translation from Mandarin Chinese reads:
%   &quot;Crouching Chuck, Hidden Norris&quot;
%
%
%   val =
%
%               id: 170
%             joke: [1x104 char]
%       categories: {0x1 cell}
%
%   >> lolChuck(struct('firstName','Mark','lastName','Tomaszewski'))
%
%   Mark Tomaszewski doesn't use a computer because a computer does everything slower
%   than Mark Tomaszewski.
%
% See also:
%
%   ICNDb:   http://www.icndb.com/api/
%   JSONlab: https://www.mathworks.com/matlabcentral/fileexchange/33381-jsonlab--a-toolbox-to-encode-decode-json-files
%
JSONLAB_URL = 'https://www.mathworks.com/matlabcentral/fileexchange/33381-jsonlab--a-toolbox-to-encode-decode-json-files';
assert(exist('loadjson.m')==2,...
  'LolChuck requires the JSONlab package. Get your copy at %s.',JSONLAB_URL);

URL_BASE = 'http://api.icndb.com/jokes/random';

if nargin>0
  p = {};
  if isfield(opts,'firstName'), p = [p,{'firstName',opts.firstName}]; end
  if isfield(opts,'lastName'), p = [p,{'lastName',opts.lastName}]; end
  [r,s] = urlread(URL_BASE,'get',p);
else
  [r,s] = urlread(URL_BASE,'get',[]);
end

assert(s==1,...
  'LolChuck failed during call to urlread()');

d = loadjson(r);
assert( strcmp('success',d.type),...
  'LolChuck failed with bad response from ICNDb API.');
% JSON response structure:
% d.type             'success' | '???'
% d.value            <struct>
% d.value.id         Joke ID number
% d.value.joke       Joke content string
% d.value.categories ???

str = d.value.joke;
str = strrep(str,'&quot;','"');
str = wrapStringToCommandWindowWidth(str);
disp(str);
if nargout>0
  varargout{1} = d.value; % return joke data
end
end

function sw = wrapStringToCommandWindowWidth(s)
szCmd = get(0,'CommandWindowSize'); % [width,height] (characters)
N = szCmd(1); P = length(s);
kk = 0; sw = '';
idxSpaces = strfind(s,' ');
while P-kk > N % characters remaining are too long for a line
  idxCut = find(idxSpaces<kk+N,1,'last');
  sw = char(sw,s(kk+1:idxSpaces(idxCut)-1));
  kk = idxSpaces(idxCut);
end
sw = char(sw,s(kk+1:end));
sw = char(sw,''); % add a line
end