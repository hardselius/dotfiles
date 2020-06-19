" Vim syntax file
" Language:     mbsync setup files
" Maintainer:   Stephen Gregoratto <themanhimself@sgregoratto.me>
" Last Change:  2019-08-10
" Filenames:    mbsyncrc
" Version:      0.3.1
" Licence:      GPLv3+
"
" Note:         This config borrows heavily from msmtprc.vim
"               by Simon Ruderich and Eric Pruitt

if v:version < 600
  syntax clear
elseif exists('b:current_syntax')
  finish
endif

" OPTIONS - Ripped directly from mbsync(1)
" All Stores
syntax match mbsyncOption /^\<\(Path\|MaxSize\|MapInbox\|Flatten\|Trash\|TrashNewOnly\|TrashRemoteNew\)\>/
" Maildir Stores
syntax match mbsyncOption /^\<\(MaildirStore\|AltMap\|Inbox\|InfoDelimiter\|SubFolders\)\>/
" IMAP4 Account
syntax match mbsyncOption /^\<\(IMAPAccount\|Host\|Port\|Timeout\|User\|Pass\|PassCmd\|Tunnel\|AuthMechs\|SSLType\|SSLVersions\|SystemCertificates\|CertificateFile\|ClientCertificate\|ClientKey\|PipelineDepth\|DisableExtension.*\)\>/
" IMAP Stores
syntax match mbsyncOption /^\<\(IMAPStore\|Account\|UseNameSpace\|PathDelimiter\)\>/
" Channels
syntax match mbsyncOption /^\<\(Channel\|Master\|Slave\|Pattern\|Patterns\|MaxSize\|MaxMessages\|ExpireUnread\|Sync\|Create\|Remove\|Expunge\|CopyArrivalDate\|SyncState\)\>/
" Groups
syntax match mbsyncOption /^\<\(Group\|Channel\)\>/
" Global
syntax match mbsyncOption /^\<\(FSync\|FieldDelimiter\|BufferLimit\)\>/

" VALUES
" Options that accept only yes|no values
syntax match mbsyncWrongOption /^\<\(TrashNewOnly\|TrashRemoteNew\|AltMap\|SystemCertificates\|UseNameSpace\|ExpireUnread\|CopyArrivalDate\|FSync\) \(yes$\|no$\)\@!.*$/
" Option SubFolders accepts Verbatim|Maildir++|Legacy
syntax match mbsyncWrongOption /^\<\(SubFolders\) \(Verbatim$\|Maildir++$\|Legacy$\)\@!.*$/
" Option SSLType accepts None|STARTTLS|IMAPS
syntax match mbsyncWrongOption /^\<\(SSLType\) \(None$\|STARTTLS$\|IMAPS$\)\@!.*$/
" Option SSLVersions accepts SSLv3|TLSv1|TLSv1.1|TLSv1.2
syntax match mbsyncWrongOption /^\<\(SSLVersions\) \(SSLv3$\|TLSv1$\|TLSv1.1$\|TLSv1.2$\)\@!.*$/
" Option Sync
syntax match mbsyncWrongOption /^\<\(Sync\) \(None$\|Pull$\|Push$\|New$\|ReNew$\|Delete$\|Flags$\|All$\)\@!.*$/
" Options Create|Remove|Expunge accept None|Master|Slave|Both
syntax match mbsyncWrongOption /^\<\(Create\|Remove\|Expunge\) \(None$\|Master$\|Slave$\|Both$\)\@!.*$/
" Marks all wrong option values as errors.
syntax match mbsyncWrongOptionValue /\S* \zs.*$/ contained containedin=mbsyncWrongOption
" Mark the option part as a normal option.
highlight default link mbsyncWrongOption mbsyncOption

" SPECIALS
" Email Addresses (yanked from esmptrc)
syntax match mbsyncAddress      /[a-z0-9_.-]*[a-z0-9]\+@[a-z0-9_.-]*[a-z0-9]\+\.[a-z]\+/
" Host names
syntax match mbsyncHost         /[a-z0-9_.-]\+\.[a-z]\+$/
" Numeric values
syntax match mbsyncNumber       /\<\(\d\+$\)/
" File Sizes
syntax match mbsyncNumber       /\d\+[k|m][b]/
" Master|Slave stores
syntax match mbsyncStores       /:[^-].*:[^-]*$/
" Strings
syntax region mbsyncString start=/"/ end=/"/
syntax region mbsyncString start=/'/ end=/'/
" Comments
syntax match mbsyncComment      /#.*$/ contains=@Spell
" File/Dir paths - Neovim exclusive
if has ('nvim')
  syntax match mbsyncPath "~\%(/[^/]\+\)\+"
endif

highlight default link mbsyncAddress            Constant
highlight default link mbsyncComment            Comment
highlight default link mbsyncHost               Constant
highlight default link mbsyncNumber             Number
highlight default link mbsyncOption             Type
highlight default link mbsyncPath               Constant
highlight default link mbsyncStores             Identifier
highlight default link mbsyncString             String
highlight default link mbsyncWrongOptionValue   Error

