# Gitago
# 8/9/2022
# Linux
# Useful Bash Script - Organize your Downloads Folder based on file type

shopt -s nullglob  ## nullifying some annoying errors from MV 

adir=$(xdg-user-dir DOWNLOAD)
cd $adir

# Setting Variables to 0 to avoid null values later
image_count=0
video_count=0
document_count=0
audio_count=0
compressed_count=0
pdf_count=0

#Create Folders
mkdir Image_Files Audio_Files Video_Files PDFs Scripts Compressed_Files

### Looping Thru Downloads Directory and Counting Certain File Types
for file in "$adir"/*; do

    ## Checking for Images
    if [[ $file =~ .*\.(png|jpg|jpeg|webp|gif) ]]; then
        let "image_count++"
        echo "[IMAGES] $file FOUND"
    fi

    ## Checking for Videos
    if [[ $file =~ .*\.(mp4|mov|avi|mpg|mpeg|webm|mpv|mp2|wmv) ]]; then
        let "video_count++"
        echo "[VIDEOS] $video_count FOUND"
    fi

    # Checking for Documents
    if [[ $file =~ .*\.(pdf|txt|doc|docx) ]]; then
        let "document_count++"
        echo "[DOCUMENTS] $document_count FOUND"
    fi
    
    # Checking for Audio
    if [[ $file =~ .*\.(m4a|flac|aac|wav|mp3) ]]; then
        let "audio_count++"
        echo "[AUDIO] $audio_count FOUND"
    fi

    # Checking for Compressed
    if [[ $file =~ .*\.(zip|rar) ]]; then
        let "compressed_count++"
        echo "[COMPRESSED] $compressed_count FOUND"
    fi

    # Checking for PDF
    if [[ $file =~ .*\.(pdf) ]]; then
        let "pdf_count++"
        echo "[PDFs] $pdf_count FOUND"
    fi      
done


## Getting the Sum of All the Files
sum=$(( $video_count + $image_count + $pdf_count + $compressed_count + $document_count + $audio_count))

## Making the Checklist / Pop Up.. cause I love GUI...
CHOICES=$(whiptail --title "Gitago's Downloads Organizer" --checklist \
"$sum files found   -   Please select the files to move" 15 60 5 \
"Images" "$image_count   " OFF \
"Videos" "$video_count   " OFF \
"Audio Files" "$audio_count   " OFF \
"Document Files" "$document_count   " OFF \
"Compressed Files" "$compressed_count   " OFF 3>&1 1>&2 2>&3) \

## when user selects...
exitstatus=$?       
if [ $exitstatus = 0 ]; then

    ## Making sure we have some sort of selection before moving forward
    if [ -z "$CHOICES" ];then
        echo "No Selection Made"
    else

        ## clearing the console - RIP to your workflow...
        #clear

        for item in $CHOICES;do

            ## Removing the " " from around the name of item to check.. 
            f_item="${item%\"}"
            f_item="${f_item#\"}"


            ## Moving Images
            if [ $f_item == Images ]; then
                if (( $image_count )) > 0;then
                    mv *.png *.jpg *.jpeg *.tif *.tiff *.bpm *.gif *.eps *.raw *.webp Image_Files
                    echo "[IMAGES] $image_count moved"
                fi
            fi


            ## Moving Videos
            if [ $f_item == Videos ]; then
                if (( $video_count )) > 0;then
                    mv *.mp4 *.mov *.avi *.mpg *.mpeg *.webm *.mpv *.mp2 *.wmv Video_Files
                    echo "[VIDEOS] - $video_count moved"
                fi
            fi


            ## Moving Audio
            if [ $f_item == Audio ]; then
                if (( $audio_count )) > 0;then
                    mv *.mp3 *.m4a *.flac *.aac *.ogg *.wav Audio_Files
                    echo "[AUDIO] - $audio_count moved"
                fi
            fi


            ## Moving Compressed
            if [ $f_item == Compressed ]; then
                if (( $compressed_count )) > 0;then
                    mv *.rar *.zip Compressed_Files
                    echo "[COMPRESSED] - $compressed_count moved"
                fi
            fi


            ## Moving Documents
            if [ $f_item == Documents ]; then
                if (( $document_count )) > 0;then
                    mv *.pdf *.txt *.doc *.docx Document_Files
                    echo "DOCUMENTS $document_count moved"
                fi
            fi
        done
    fi
else
    echo "CANCELLED!"
fi









